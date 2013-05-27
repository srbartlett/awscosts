require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run the tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = ENV['rspec_pattern'] || "spec/**/*_spec.rb"
  t.rspec_opts = [
    "--colour",
    "--format documentation",
    "--require",  "spec_helper"
  ]
end
