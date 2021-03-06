# frozen_string_literal: true

require "test_helper"

module ObsidianBear
  class BearTest < Minitest::Test
    def test_extract_tags_correctly_identify_tags_per_note
      summary = Bear.new(note_paths: [
        "test/data/bear/note_1.md",
        "test/data/bear/note_2.md",
      ]).extract_tags

      assert_equal(
        {
          "test/data/bear/note_1.md" => ["groceries/tasks"],
          "test/data/bear/note_2.md" => ["work/tasks"],
        },
        summary
      )
    end

    def test_extract_tags_extracts_multiple_tags_in_file
      summary = Bear.new(note_paths: [
        "test/data/bear/multiple_tags.md",
      ]).extract_tags

      assert_equal(
        {
          "test/data/bear/multiple_tags.md" => ["groceries/tasks", "work/tasks"],
        },
        summary
      )
    end

    def test_extract_multiple_tags_in_line
      summary = Bear.new(note_paths: [
        "test/data/bear/multiple_tags_same_line.md",
      ]).extract_tags

      assert_equal(
        {
          "test/data/bear/multiple_tags_same_line.md" => ["multi_word", "programming/ruby", "programming_bear", "simple", "programming/rust", "testing"],
        },
        summary
      )
    end

    def test_prioritize_tags_with_more_specificity
      summary = Bear.new(note_paths: [
        "test/data/bear/specific_tags_same_line.md",
      ]).extract_tags

      assert_equal(
        {
          "test/data/bear/specific_tags_same_line.md" => ["programming/ruby"],
        },
        summary
      )
    end

    def test_extract_tags_returns_emtpy_hash_when_no_tags_are_found
      summary = Bear.new(note_paths: [
        "test/data/bear/no_tags.md",
      ]).extract_tags

      assert_equal(
        {
          "test/data/bear/no_tags.md" => [],
        },
        summary
      )
    end
  end
end
