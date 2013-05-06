desc "lint application javascript"
task :coffeelint do
  fail 'Lint!' unless Coffeelint.run_test('.')
end
