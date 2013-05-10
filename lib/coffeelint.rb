require "coffeelint/version"
require 'execjs'
require 'coffee-script'

module Coffeelint
  require 'coffeelint/railtie' if defined?(Rails)

  def self.path()
    @path ||= File.expand_path('../../coffeelint/src/coffeelint.coffee', __FILE__)
  end

  def self.lint(script, config = {})
    coffeescriptSource = File.read(CoffeeScript::Source.path)
    coffeelintSource = CoffeeScript.compile(File.read(Coffeelint.path))
    context = ExecJS.compile(coffeescriptSource + coffeelintSource)
    context.call('coffeelint.lint', script, config)
  end

  def self.lint_file(filename, config = {})
    Coffeelint.lint(File.read(filename), config)
  end

  def self.lint_dir(directory, config = {})
    retval = {}
    Dir.glob("#{directory}/**/*.coffee") do |name|
      retval[name] = Coffeelint.lint_file(name, config)
      yield name, retval[name] if block_given?
    end
    retval
  end

  def self.display_test_results(name, errors)
    good = "\u2713"
    bad = "\u2717"

    if errors.length == 0
      puts "  #{good} \e[1m\e[32m#{name}\e[0m"
      return true
    else
      puts "  #{bad} \e[1m\e[31m#{name}\e[0m"
      errors.each do |error|
        puts "     #{bad} \e[31m##{error["lineNumber"]}\e[0m: #{error["message"]}, #{error["context"]}."
      end
      return false
    end
  end

  def self.run_test(file, config = {})
    result = Coffeelint.lint_file(file, config)
    Coffeelint.display_test_results(file, result)
  end

  def self.run_test_suite(directory, config = {})
    success = true
    Coffeelint.lint_dir(directory, config) do |name, errors|
      result = Coffeelint.display_test_results(name, errors)
      success = false if not result
    end
    success
  end
end
