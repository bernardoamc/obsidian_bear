# frozen_string_literal: true

require "test_helper"

class ObsidianBearTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ObsidianBear::VERSION
  end

  def test_migrate_migrates_notes_from_bear_to_obsidian
    FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
    FileUtils.cp(Dir.glob("test/data/bear/*.md"), 'test/data/obsidian')

    ObsidianBear.migrate(notes_path: 'test/data/obsidian')

    assert File.exist?("test/data/obsidian/groceries/tasks/note_1.md")
    assert File.exist?("test/data/obsidian/work/tasks/note_2.md")
    assert File.exist?("test/data/obsidian/no_tags.md")
    assert File.exist?("test/data/obsidian/groceries/tasks/multiple_tags.md")
    assert File.exist?("test/data/obsidian/work/tasks/multiple_tags.md")

    refute File.exist?("test/data/obsidian/note_1.md")
    refute File.exist?("test/data/obsidian/note_2.md")
    refute File.exist?("test/data/obsidian/multiple_tags.md")

    FileUtils.rm_r(Dir.glob("test/data/obsidian/*"))
  end
end
