# frozen_string_literal: true

require "test_helper"

module ObsidianBear
  class ObsidianTest < Minitest::Test
    def setup
      FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
      FileUtils.cp(Dir.glob("test/data/bear/*.md"), 'test/data/obsidian')
    end

    def test_migrate_migrates_file_with_tags
      input = {
        "test/data/obsidian/note_1.md" => ["groceries/tasks"],
        "test/data/obsidian/note_2.md" => ["work/tasks"],
      }

      Obsidian.new(tags_by_note_path: input).migrate

      assert File.exist?("test/data/obsidian/groceries/tasks/note_1.md")
      assert File.exist?("test/data/obsidian/work/tasks/note_2.md")
      refute File.exist?("test/data/obsidian/note_1.md")
      refute File.exist?("test/data/obsidian/note_2.md")
    end

    def test_migrate_skip_file_without_tags
      input = { "test/data/obsidian/no_tags.md" => [] }

      Obsidian.new(tags_by_note_path: input).migrate

      assert File.exist?("test/data/obsidian/no_tags.md")
    end

    def test_migrate_migrates_file_with_multiple_tags
      input = {
        "test/data/obsidian/multiple_tags.md" => ["groceries/tasks", "work/tasks"],
      }

      Obsidian.new(tags_by_note_path: input).migrate

      assert File.exist?("test/data/obsidian/groceries/tasks/multiple_tags.md")
      assert File.exist?("test/data/obsidian/work/tasks/multiple_tags.md")
      refute File.exist?("test/data/obsidian/multiple_tags.md")
    end


    def teardown
      FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
    end
  end
end
