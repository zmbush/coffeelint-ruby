desc "lint application javascript"
task :coffeelint do
  success = Coffeelint.run_test_suite('app') and Coffeelint.run_test_suite('spec')
  fail "Lint!" unless success
end
