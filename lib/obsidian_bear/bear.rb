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
    # 1. Starting with # when the tag has not spaces: "#programming"
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
    # 1. If a tag ends with '#' we strip it and replace splaces with underscores
    # 2. If not we split by space and get the first value since the rest is not
    #    supposed to be a tag
    # 3. Last but not least we strip any starting '#'
    def format_tag(str)
      tag = if str.end_with?('#')
        str.chop.gsub(/[^\w\/]/, '_')
      else
        str.split.first
      end

      tag = tag[1..] if tag.start_with?('#')
      tag
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
