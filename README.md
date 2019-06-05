# boo (simple command tool for Boostnote)

Create Boostnote note from command line.

```
boo [folder] [tag1] [tag2] ... [content]
```

## How to use

### install Boostnote and setup

See https://boostnote.io/

### confirm boo dependent command line tools

- jq
- uuidgen

If you didn't have, install them.

### install boo

- via fisher

```fish
fisher add mk2/boo
```

### set `BOOSTNOTE_DATA_DIRECTORY`

Set the path of the directory which you have stored Boostnote data.

Example:

```fish
set -x BOOSTNOTE_DATA_DIRECTORY ~/Documents/Boostnote # recommend it will be persisted in config.fish
```

### use boo

```fish
boo Todo "My first memo by boo"
```

- The command saves the note under `$BOOSTNOTE_DATA_DIRECTORY/notes`
