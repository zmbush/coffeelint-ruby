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
end
