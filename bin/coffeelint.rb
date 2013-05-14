#!/usr/bin/env ruby

require 'coffeelint'
require 'coffeelint/version'
require 'optparse'

options = {
            :recursive => false,
            :noconfig => false,
            :stdin => false,
            :quiet => false,
          }
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: coffeelint.rb [options] source [...]"

=begin
-f, --file     Specify a custom configuration file.               
--noconfig     Ignores the environment variable COFFEELINT_CONFIG.  [boolean]
-h, --help     Print help information.                            
-v, --version  Print current version number.                      
-r             Recursively lint .coffee files in subdirectories.    [boolean]
--csv          Use the csv reporter.                                [boolean]
--jslint       Use the JSLint XML reporter.                         [boolean]
--nocolor      Don't colorize the output                            [boolean]
-s, --stdin    Lint the source from stdin                           [boolean]
-q, --quiet    Only print errors.                                   [boolean]
=end


  opts.on "-f", "--file", "Specify a custom configuration file." do |f|
    options[:config_file] = f
  end

  opts.on "--noconfig", "Ignores the environment variabel COFFEELINT_CONFIG." do |f|
    options[:noconfig] = true
  end

  opts.on_tail "-h", "--help", "Print help information." do
    puts opts
    exit
  end

  opts.on_tail "-v", "--version", "Print current version number." do
    puts Coffeelint::VERSION
    exit
  end

  opts.on '-r', "Recursively lint .coffee files in subdirectories." do
    options[:recursive] = true
  end

  opts.on '-s', '--stdin', "Lint the source from stdin" do
    options[:stdin] = true
  end

  opts.on '-q', '--quiet', 'Only print errors.' do
    options[:quiet] = true
  end
end

opt_parser.parse!

if ARGV.length > 0
  ARGV.each do |file|
    if options[:recursive]
      Coffeelint.run_test_suite(file)
    else
      Coffeelint.run_test(file)
    end
  end
else
  puts opt_parser
end
