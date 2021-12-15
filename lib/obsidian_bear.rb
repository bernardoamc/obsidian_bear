# frozen_string_literal: true

require_relative "obsidian_bear/version"
require_relative "obsidian_bear/bear"
require_relative "obsidian_bear/obsidian"

module ObsidianBear
  class Error < StandardError; end

  def self.migrate(notes_path:)
    unless Dir.exist?(notes_path)
      puts "Notes directory not found, aborting!"
      return
    end

    attachments_path = File.join(notes_path, 'attachments')
    unless Dir.exist?(attachments_path)
      puts "Creating attachments folder..."
      FileUtils.mkdir(attachments_path)
    end

    puts "Fetching notes..."
    note_paths = Dir.glob("#{notes_path}/*.md").to_a

    puts "Extracting tags..."
    tags_by_note = Bear.new(note_paths: note_paths).extract_tags

    obsidian = Obsidian.new(notes_path: notes_path, tags_by_note_path: tags_by_note)

    puts "Migrating folders into attachments..."
    obsidian.migrate_folders(attachments_path)

    puts "Fixing inline image links..."
    obsidian.fix_inline_links(note_paths: note_paths)

    puts "Migrating notes..."
    obsidian.migrate_notes

    puts "Done!"
  end
end
