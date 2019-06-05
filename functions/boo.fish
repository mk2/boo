function boo
	_is_valid_boostnote_data_directory; or return 1
	set -l folder $argv[1]
	if test (count $argv) -eq 3
		set tags $argv[2]
		set content $argv[3]
	else
		set content $argv[2]
	end
	set -l folder_key (_find_given_folder_key $folder); or return 1
	_write_cson $folder $tags $content
end

function _write_cson -a folder tags content
	set -l now (date "+%Y-%m-%dT%H:%M:%S.000Z")
	set -l createdAt "createdAt: $now"
	set -l updatedAt "updatedAt: $now"
	set -l type "type: MARKDOWN_NOTE"
	set -l folder "folder: $folder"
	set -l title "title: $content"
	set -l tags "tags: [ $tags ]"
	set -l content "content: '''$content'''"
	set -l linesHighlighted "linesHighlighted: []"
	set -l isStarred "isStarred: false"
	set -l isTrashed "isTrashed: false"
	string join \n $createdAt $updatedAt $type $folder $title $tags $content $linesHighlighted $isStarred $isTrashed
end

function _find_given_folder_key -a folder
	set -l folder_key  (jq -r ".folders | map(select(.name == \"$folder\"))[] | .key" "$BOOSTNOTE_DATA_DIRECTORY/boostnote.json")
	if test -z $folder_key
		echo "*** $folder is not a valid folder." >&2
		return 1
	end
	echo $folder_key
end

function _is_valid_boostnote_data_directory
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
