# ObsidianBear

Are you ready to migrate from Bear to Obsidian, let's go!

## Steps

We have to execute a few steps before we run this code.

1. Export from Bear as Markdown+Attachments to a folder called `notes`
2. Create an `attachment` folder under the `notes` folder (`notes/attachments`)
3. Move all _folders_ beneath the `notes` folder to the `attachments` folder.
   - For example: `notes/tasks` -> `notes/attachments/tasks`
4. Fix all inline image links by running the code below on a shell opened on the _notes_ folder:

```sh
$ find . -type f -name "*.md" -exec bash -c 'sed -E "s/\!\[\]\(/\!\[\]\(attachments\//" "$1" > tempfile; touch -r "$1" tempfile; mv tempfile "$1"' -- {} \;
```

5. Finally, run our code:

```sh
bundle exec rake migrate <notes_path>
```

You can get the right path by running the following command in the _notes path_:

```sh
$ pwd
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bernardoamc/obsidian_bear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
