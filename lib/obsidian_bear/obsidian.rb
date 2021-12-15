# frozen_string_literal: true

require "fileutils"

module ObsidianBear
  class Obsidian
    def initialize(tags_by_note_path: [])
      @tags_by_note_path = tags_by_note_path
    end

    def migrate
      @tags_by_note_path.each do |note_path, tags|
        next if tags.empty?
        move_note(note_path, tags)
      end
    end

    private

    def move_note(original_note, tags)
      name = File.basename(original_note)
      original_path = File.dirname(original_note)

      tags.each do |tag|
        create_folders(original_path, tag)
        new_note = File.join(original_path, tag, name)
        FileUtils.cp(original_note, new_note)
      end

      FileUtils.rm(original_note)
    end

    def create_folders(original_path, tag)
      new_path = File.join(original_path, tag)
      FileUtils.mkdir_p(new_path) unless Dir.exist?(new_path)
    end
  end
end
