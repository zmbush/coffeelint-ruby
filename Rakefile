require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new('spec')

task :default => :spec

task :console do
  sh "irb -rubygems -I lib -r coffeelint.rb"
end

task :prepare_coffeelint do
  sh "git submodule init"
  sh "git submodule update"

  Dir.chdir('coffeelint') do
    sh "npm install"
    sh "npm run compile"
  end
end

task :compile => [:prepare, :build]

task :prepare do
  sh "git submodule init"
  sh "git submodule update"

  Dir.chdir('coffeelint') do
    sh "npm install"
    sh "npm run compile"
  end

  sh "rake spec"
end
