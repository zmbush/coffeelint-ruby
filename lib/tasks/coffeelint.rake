desc "lint application javascript"
task :coffeelint do
  success = (Coffeelint.run_test_suite('app') == 0) and (Coffeelint.run_test_suite('spec') == 0)
  fail "Lint!" unless success
end
