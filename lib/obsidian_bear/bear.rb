# frozen_string_literal: true

module ObsidianBear
  class Bear
    LINE_TAG_TEST = %r{\A#\w+}.freeze
    ATTACHMENT_FORMAT = %r{\!\[\]\((?<path>.*)\)}.freeze

    def initialize(note_paths: [])
      @note_paths = note_paths
    end

    def extract_tags
      @note_paths.reduce({}) do |tags, note_path|
        note_tags = []

        File.readlines(note_path).each do |line|
          line = line.strip

          if line.match(LINE_TAG_TEST)
            # We might have multiple tags within the same line
            note_tags += line.split(' #').map { |str| format_tag(str) }
          end
        end

        tags[note_path] = find_unique_tag_paths(note_tags)
        tags
      end
    end

    private

    # Tags have two distinct formats:
    #
    # 1. Starting with # when the tag has no spaces: "#programming"
    # 2. Enclosing # and the tag can contain spaces: "#programming ruby#"
    #
    # Since we are splitting by " #" we end up with malformed tags at their
    # boundaries. For example:
    #
    # #programming #programming/ruby and #cool tag#
    #
    # Once split this becomes:
    #
    # ["#programming", "programming/ruby and", "cool tag#"]
    #
    # A second example:
    #
    # #multi word# and #programming/ruby and #cool tag#
    #
    # Once split this becomes:
    #
    # ["#multi word# and", "programming/ruby and", "cool tag#"]
    #
    # 1. If a tag contains "#" in any other position besides the first character
    #    we know it is a multi word tag
    # 2. Otherwise we know we have a simple tag
    #
    # Based on this we can make the following decisions
    #
    # 1. Strip any starting '#'
    # 2. If we have a multi tag we read until the last '#' and replace spaces
    #    with underscores
    # 3. If not we split by space and get the first element since the rest is not
    #    supposed to be a tag
    def format_tag(str)
      multi_tag = str[1..].include?('#')
      str = str[1..] if str.start_with?('#')

      if multi_tag
        extract_multi_tag(str)
      else
        str.split.first
      end
    end

    def extract_multi_tag(str)
      last_separator = str.rindex('#')
      str[...last_separator].gsub(/[^\w\/]/, '_')
    end

    # If we have a tag called "programming" and one called "programming/ruby"
    # we want to keep only "programming/ruby" since it's more specific.
    def find_unique_tag_paths(tags)
      return tags if tags.empty?

      rejected_tags = []

      tags.each do |tag1|
        tags.each do |tag2|
          next if tag1 == tag2

          if tag2.start_with?(tag1)
            rejected_tags << tag1
            break
          end
        end
      end

      tags - rejected_tags
    end
  end
end
