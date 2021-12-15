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

    puts "Fetching notes..."
    note_paths = Dir.glob("#{notes_path}/*.md").to_a

    puts "Extracting tags..."
    tags_by_note = Bear.new(note_paths: note_paths).extract_tags

    puts "Migrating notes..."
    Obsidian.new(tags_by_note_path: tags_by_note).migrate

    puts "Done!"
  end
end
