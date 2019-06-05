# boo (simple command tool for Boostnote)

## How to use

### install Boostnote and setup

See https://boostnote.io/

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

- Previous command saves the note under `$BOOSTNOTE_DATA_DIRECTORY/notes`