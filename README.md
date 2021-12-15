# ObsidianBear

Are you ready to migrate from Bear to Obsidian, let's go!

## Steps

We have to execute a few steps before we run this code.

1. Export from Bear as `Markdown + Attachments` to a folder
2. Backup your notes, seriously.
3. Copy the `full path` of your notes folder

You can get the full path by running the following command in your _notes folder_:

```sh
$ pwd
```

4. Finally, run our code:

```sh
bundle exec rake migrate <notes_path>
```

5. Enjoy Obsidian!

## Caveats

When a note has _multiple tags_ the note will be duplicate into folders for each tag.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bernardoamc/obsidian_bear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
