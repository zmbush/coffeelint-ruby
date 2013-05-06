require 'spec_helper'

describe Coffeelint do
  it 'should error with semicolon' do
    results = Coffeelint.lint('apple;')
    results.length.should == 1
    result = results[0]
    result['message'].should include 'trailing semicolon'
  end
end
