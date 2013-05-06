# Coffeelint

Coffeelint is a set of simple ruby bindings for [coffeelint](https://github.com/clutchski/coffeelint).

## Installation

Add this line to your application's Gemfile:

    gem 'coffeelint'

Or for the most up to date version:

    gem 'coffeelint', :git => 'git://github.com/zipcodeman/coffeelint-ruby.git', :submodules => true

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coffeelint

## Usage

There are a few different uses of coffeelint.

    lint_report = Coffeelint.lint(coffeescript source code)
    lint_report = Coffeelint.lint_file(filename of coffeescript source)
    lint_reports = Coffeelint.lint_dir(directory)
    Coffeelint.lint_dir(directory) do |filename, lint_report|
        puts filename
        puts lint_report
    end

Additionally, if you are using rails you also get the rake task:

    rake coffeelint

Which will run the test on any *.coffee file in your project

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
