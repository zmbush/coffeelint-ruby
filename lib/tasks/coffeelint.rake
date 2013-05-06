desc "lint application javascript"
task :coffeelint do
  files = Coffeelint.lint_dir('.')
  files.each do |name, errors|
    name = name[2..-1]

    good = "\u2713"
    bad = "\u2717"

    if errors.length == 0
      puts "#{good} #{name}"
    else
      puts "#{bad} #{name}"
      errors.each do |error|
        puts "    ##{error["lineNumber"]}: #{error["message"]}, #{error["context"]}."
      end
    end
  end
end
