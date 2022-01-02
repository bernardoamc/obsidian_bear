# ObsidianBear

Are you ready to migrate from Bear to Obsidian? Let's go!

This tool will:

1. Parse Bear tags, create folders for each tag name and move notes to the appropriate folders
2. Adjust attachments from Bear to Obsidian format

Tags with a forward slash will create subfolders, for example:

`#programming/ruby` will create the `programming` folder and a `ruby` folder inside it.

Spaces within tags will be converted to underscore, for example:

`#programming ruby#` will create a folder named `programming_ruby`

## Prerequisites

We need to have the following installed:

1. [git](https://github.com/git-guides/install-git)
2. [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
3. [bundler](https://bundler.io/)

Followed by these commands in your terminal:

1. `git clone https://github.com/bernardoamc/obsidian_bear.git`
2.  Go to this new folder: `cd obsidian_bear`

### Export your Bear notes

1. Export from Bear as `Markdown + Attachments` to a folder
2. Backup your notes, seriously.
3. Copy the `full path` of your notes folder

You can get the full path by running the following command in your _notes folder_:

```sh
$ pwd
```

## Running the tool

```sh
bundle exec rake migrate <notes_path>
```

Enjoy Obsidian!

## Caveats

When a note has _multiple tags_ the note will be duplicated into folders for each tag.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bernardoamc/obsidian_bear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
