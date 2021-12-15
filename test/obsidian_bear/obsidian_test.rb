# frozen_string_literal: true

require "test_helper"

module ObsidianBear
  class ObsidianTest < Minitest::Test
    def setup
      FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
      FileUtils.cp(Dir.glob("test/data/bear/*.md"), 'test/data/obsidian')
    end

    def test_migrate_folders
      FileUtils.mkdir_p("test/data/obsidian/images")
      FileUtils.mkdir_p("test/data/obsidian/attachments")
      assert Dir.exist?("test/data/obsidian/images")
      assert Dir.exist?("test/data/obsidian/attachments")

      Obsidian.new(notes_path: "test/data/obsidian/").migrate_folders("test/data/obsidian/attachments")

      assert Dir.exist?("test/data/obsidian/attachments")
      assert Dir.exist?("test/data/obsidian/attachments/images")
      refute Dir.exist?("test/data/obsidian/images")
    end

    def test_fix_inline_images
      note_paths = ["test/data/obsidian/note_with_attachment.md"]
      Obsidian.new(notes_path: "test/data/obsidian/").fix_inline_links(note_paths: note_paths)
      assert File.exist?(note_paths.first)
      assert(File.readlines(note_paths.first).any? { |line| line.match(Obsidian::ATTACHMENT_FORMAT) })
    end

    def test_migrate_migrates_file_with_tags
      input = {
        "test/data/obsidian/note_1.md" => ["groceries/tasks"],
        "test/data/obsidian/note_2.md" => ["work/tasks"],
      }

      Obsidian.new(
        notes_path: "test/data/obsidian",
        tags_by_note_path: input
      ).migrate_notes

      assert File.exist?("test/data/obsidian/groceries/tasks/note_1.md")
      assert File.exist?("test/data/obsidian/work/tasks/note_2.md")
      refute File.exist?("test/data/obsidian/note_1.md")
      refute File.exist?("test/data/obsidian/note_2.md")
    end

    def test_migrate_skip_file_without_tags
      input = { "test/data/obsidian/no_tags.md" => [] }

      Obsidian.new(
        notes_path: "test/data/obsidian",
        tags_by_note_path: input
      ).migrate_notes

      assert File.exist?("test/data/obsidian/no_tags.md")
    end

    def test_migrate_migrates_file_with_multiple_tags
      input = {
        "test/data/obsidian/multiple_tags.md" => ["groceries/tasks", "work/tasks"],
      }

      Obsidian.new(
        notes_path: "test/data/obsidian",
        tags_by_note_path: input
      ).migrate_notes

      assert File.exist?("test/data/obsidian/groceries/tasks/multiple_tags.md")
      assert File.exist?("test/data/obsidian/work/tasks/multiple_tags.md")
      refute File.exist?("test/data/obsidian/multiple_tags.md")
    end


    def teardown
      FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
    end
  end
end
