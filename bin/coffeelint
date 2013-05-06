#!/usr/bin/env ruby

require 'coffeelint'
require 'optparse'

options = {:recursive => false}
OptionParser.new do |opts|
  opts.banner = "Usage: coffeelint [options] source [...]"

  opts.on '-r', "Recursively lint .coffee files in subdirectories." do |f|
    options[:recursive] = f
  end
end.parse!

ARGV.each do |file|
  if options[:recursive]
    Coffeelint.run_test_suite(file)
  else
    Coffeelint.run_test(file)
  end
end
