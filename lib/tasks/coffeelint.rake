desc "lint application javascript"
task :coffeelint do
  conf = {}

  config_file = [].tap {|files|
    files << ENV['COFFEELNT_CONFIG'] if ENV['COFFEELENT_CONFIG']
    files << 'config/coffeelint.json'
    if ENV['HOME']
      files << "#{ENV['HOME']}/coffeelint.json"
      files << "#{ENV['HOME']}/.coffeelint.json"
    end
  }.compact.detect {|file| File.exists?(file) }

  conf[:config_file] = config_file if config_file
  success = Coffeelint.run_test_suite('app', conf) and Coffeelint.run_test_suite('spec', conf)
  fail "Lint!" unless success
end
