desc "lint application javascript"
task :coffeelint do
  files = Coffeelint.lint_dir('.')
  files.each do |name, errors|
    name = name[2..-1]
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
