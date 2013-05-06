require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new('spec')

task :default => :spec

task :console do
  sh "irb -rubygems -I lib -r coffeelint.rb"
end

