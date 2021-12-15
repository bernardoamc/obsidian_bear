# frozen_string_literal: true

module ObsidianBear
  class Bear
    TAG_FORMAT = %r{\A#(\w+)(/\w+)*\z}.freeze
    ATTACHMENT_FORMAT = %r{\!\[\]\((?<path>.*)\)}.freeze

    def initialize(note_paths: [])
      @note_paths = note_paths
    end

    def extract_tags
      @note_paths.reduce({}) do |tags, note_path|
        tags[note_path] = []

        File.readlines(note_path).each do |line|
          line = line.strip
          tags[note_path] << line[1..] if line.match(TAG_FORMAT)
        end

        tags
      end
    end
  end
end
