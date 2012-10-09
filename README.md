# mvr - Move with regex

`mvr` is a little program that uses regular expressions to help move files around.

## Requirements

* `ruby 2.0.0` - probably works with 1.9.7, good luck with 1.8.7

## Usage

Once `mvr` is in your path...

    mvr foo bar                           # Standard usage as `mv`
    mvr '.*' '$0-changed'                 # Capture using regular expressions. Access the whole match (i.e. original filename) with $0
    mvr 'sample-(\d+)' 's$1'              # Capture groups accessed using $1, $2, $3...
    mvr 'sample(\d+)-1.txt' 's$(1)1.txt'  # You can always use $(1) instead of $1 to prevent confusion
    mvr 'sample1.txt' '$$1.txt'           # Use $$ to represent $.

A word of warning - `mvr 'foo' 'bar'` will only match files named `foo`, not files with `foo` in them. E.g.

    ls
    > file1
    > file2
    > file3
    mvr '\d' '-$0' # won't do anything

### Flags

-v
: Verbose mode. Will inform you of every file change.

-d
: Dryrun. Will not actually move any files.

-c
: Confirm. Will show you the results of your action and seek confirmation before continuing.