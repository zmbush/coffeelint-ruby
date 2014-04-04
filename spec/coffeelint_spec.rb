require 'spec_helper'

describe Coffeelint do
  it 'should error with semicolon' do
    results = Coffeelint.lint('apple;')
    results.length.should == 1
    result = results[0]
    result['message'].should include 'trailing semicolon'
  end

  it 'should be able to disable a linter' do
    results = Coffeelint.lint('apple;', :no_trailing_semicolons =>  { :level => "ignore" } )
    results.length.should == 0
  end

  it 'should be able to take a config file in the parameters' do
    File.open('/tmp/coffeelint.json', 'w') {|f| f.write(JSON.dump({:no_trailing_semicolons => { :level => "ignore" }})) }
    results = Coffeelint.lint('apple;', :config_file => "/tmp/coffeelint.json")
    results.length.should == 0
  end

  it 'should report missing fat arrow' do
    results = Coffeelint.lint "hey: ->\n  @bort()\n", :missing_fat_arrows => { :level => "error" }
    results.length.should == 1
  end

  it 'should report unnecessary fat arrow' do
    results = Coffeelint.lint "hey: =>\n  bort()\n", :no_unnecessary_fat_arrows => { :level => "error" }
    results.length.should == 1
  end

  it 'should report cyclomatic complexity' do
    results = Coffeelint.lint(<<-EOF, :cyclomatic_complexity => { :level => "error" })
      x = ->
        1 and 2 and 3 and
        4 and 5 and 6 and
        7 and 8 and 9 and
        10 and 11
    EOF
    results.length.should == 1
    results[0]['name'].should == 'cyclomatic_complexity'
  end
end
