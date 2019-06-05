function boo
  _boo_is_valid_boostnote_data_directory; or return 1
  set -l folder $argv[1]
  set -l raw_tags ""
  set -l content $argv[-1]
  if test (count $argv) -gt 2
    set raw_tags $argv[2..-2]
  end
  set -l folder_key (_boo_find_given_folder_key $folder); or return 1
  set -l note_key (command uuidgen | string lower)
  _boo_write_cson "$folder_key" "$raw_tags" "$content" > $BOOSTNOTE_DATA_DIRECTORY/notes/$note_key.cson
end

function _boo_write_cson -a folder_key raw_tags content
  set -l now (date "+%Y-%m-%dT%H:%M:%S.000Z")
  set -l createdAt "createdAt: \"$now\""
  set -l updatedAt "updatedAt: \"$now\""
  set -l type "type: \"MARKDOWN_NOTE\""
  set -l folder "folder: \"$folder_key\""
  set -l title "title: \"$content\""
  set -l tags "tags: []"
  if test ! -z $raw_tags
    set tags "tags: [" (_boo_create_tags_property $raw_tags) "]"
  end
  set -l content "content: '''$content'''"
  set -l linesHighlighted "linesHighlighted: []"
  set -l isStarred "isStarred: false"
  set -l isTrashed "isTrashed: false"
  string join \n $createdAt $updatedAt $type $folder $title $tags $content $linesHighlighted $isStarred $isTrashed
end

function _boo_create_tags_property -a raw_tags
  for raw_tag in (string split " " $raw_tags)
    echo "  \"$raw_tag\""
  end
end

function _boo_find_given_folder_key -a folder
  set -l folder_key  (command jq -r ".folders | map(select(.name == \"$folder\"))[] | .key" "$BOOSTNOTE_DATA_DIRECTORY/boostnote.json")
  if test -z $folder_key
    echo "*** $folder is not a valid folder." >&2
    return 1
  end
  echo $folder_key
end

function _boo_extract_folders
  _boo_is_valid_boostnote_data_directory; or return 1
  jq -r ".folders[].name" "$BOOSTNOTE_DATA_DIRECTORY/boostnote.json"
end

function _boo_is_valid_boostnote_data_directory
  if not set -q BOOSTNOTE_DATA_DIRECTORY
    echo "*** Not found BOOSTNOTE_DATA_DIRECTORY. Please set it to environment." >&2
    return 1
  end
  if test ! -e "$BOOSTNOTE_DATA_DIRECTORY"
    echo "*** $BOOSTNOTE_DATA_DIRECTORY not exist." >&2
    return 1
  end
  if test ! -d "$BOOSTNOTE_DATA_DIRECTORY"
    echo "*** $BOOSTNOTE_DATA_DIRECTORY not directory." >&2
    return 1
  end
  if test ! -e "$BOOSTNOTE_DATA_DIRECTORY/boostnote.json"
    echo "*** $BOOSTNOTE_DATA_DIRECTORY not contains boostnote.json." >&2
    return 1
  end
  if test ! -d "$BOOSTNOTE_DATA_DIRECTORY/notes"
    echo "*** $BOOSTNOTE_DATA_DIRECTORY not contains notes/." >&2
    return 1
  end
end
