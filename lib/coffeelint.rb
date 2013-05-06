require "coffeelint/version"
require 'execjs'
require 'coffee-script'

module Coffeelint
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
    Dir.glob("#{directory}/*.coffee") do |name|
      Coffeelint.lint_file(name)
    end
  end
end
