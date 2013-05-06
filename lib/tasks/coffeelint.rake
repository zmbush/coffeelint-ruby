desc "lint application javascript"
task :coffeelint do
  files = Coffeelint.lint_dir('app/assets/javascripts')
  files.each do |name, errors|
    if errors.length == 0
      puts "+ #{name}"
    else
      puts "- #{name}"
      errors.each do |error|
        puts "    ##{error["lineNumber"]}: #{error["message"]}, #{error["context"]}."
      end
    end
  end
end
