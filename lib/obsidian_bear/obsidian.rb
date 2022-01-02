# frozen_string_literal: true

require "cgi"
require "fileutils"

module ObsidianBear
  class Obsidian
    ATTACHMENTS_FOLDER = 'attachments'
    ATTACHMENT_FORMAT = %r{\!\[\[.*\]\]}.freeze

    def initialize(notes_path:, tags_by_note_path: {})
      @notes_path = notes_path
      @tags_by_note_path = tags_by_note_path
    end

    def migrate_folders(attachments_path)
      entries = Dir.entries(@notes_path) - ['.', '..']

      entries.each do |entry|
        path = File.join(@notes_path, entry)

        next unless File.directory?(path)
        next if entry == ATTACHMENTS_FOLDER

        FileUtils.cp_r(path, attachments_path)
        FileUtils.rm_r(path)
      end
    end

    def fix_inline_links(note_paths: [])
      migration_temp = File.join(@notes_path, "obsidian_bear_temp")
      unless Dir.exist?(migration_temp)
        FileUtils.mkdir(migration_temp)
      end

      note_paths.each do |note_path|
        note = File.basename(note_path)
        lines = File.readlines(note_path)

        next unless lines.any? { |line| line.match(Bear::ATTACHMENT_FORMAT) }
        temp_note = File.join(migration_temp, note)
        FileUtils.touch([temp_note])

        File.open(temp_note, "w+") do |f|
          lines.each do |line|
            if !line.match(Bear::ATTACHMENT_FORMAT)
              f.puts line
              next
            end

            f.puts line.gsub(Bear::ATTACHMENT_FORMAT) { |_|
                match = Regexp.last_match
                updated_link = File.join(ATTACHMENTS_FOLDER, match[:path])
                "![[#{CGI.unescape(updated_link)}]]"
            }
          end
        end

        FileUtils.cp(temp_note, note_path)
      end

      FileUtils.rm_r(migration_temp)
    end

    def migrate_notes
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
