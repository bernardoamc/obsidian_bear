# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Migrate from Bear to Obsidian. Usage: bundle exec migrate <notes_path>"
task :migrate do
  require_relative "lib/obsidian_bear.rb"

  ObsidianBear.migrate(notes_path: ARGV[1])
end


require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test rubocop]
