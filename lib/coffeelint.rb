require "coffeelint/version"
require 'execjs'
require 'coffee-script'

module Coffeelint
  require 'coffeelint/railtie' if defined?(Rails)

  def self.path()
    @path ||= File.expand_path('../../coffeelint/src/coffeelint.coffee', __FILE__)
  end

  def self.lint(script)
    coffeescriptSource = File.read(CoffeeScript::Source.path)
    coffeelintSource = CoffeeScript.compile(File.read(Coffeelint.path))
    context = ExecJS.compile(coffeescriptSource + coffeelintSource)
    context.call('coffeelint.lint', script)
  end

  def self.lint_file(filename)
    Coffeelint.lint(File.read(filename))
  end

  def self.lint_dir(directory)
    retval = {}
    Dir.glob("#{directory}/**/*.coffee") do |name|
      retval[name] = Coffeelint.lint_file(name)
      yield name, retval[name]
    end
    retval
  end

  def self.run_test(directory)
    success = true
    Coffeelint.lint_dir('.') do |name, errors|
      name = name[2..-1]

      good = "\u2713"
      bad = "\u2717"

      if errors.length == 0
        puts "  #{good} \e[1m\e[32m#{name}\e[0m"
      else
        success = false
        puts "  #{bad} \e[1m\e[31m#{name}\e[0m"
        errors.each do |error|
          puts "     #{bad} \e[31m##{error["lineNumber"]}\e[0m: #{error["message"]}, #{error["context"]}."
        end
      end
    end
    success
  end
end
