require 'spec_helper'

describe Coffeelint do
  it 'should error with semicolon' do
    results = Coffeelint.lint('apple;')
    expect(results.length).to eq 1
    result = results[0]
    expect(result['message']).to include 'trailing semicolon'
  end

  it 'should be able to disable a linter' do
    results = Coffeelint.lint('apple;', :no_trailing_semicolons =>  { :level => "ignore" } )
    expect(results.length).to eq 0
  end

  it 'should be able to take a config file in the parameters' do
    File.open('/tmp/coffeelint.json', 'w') {|f| f.write(JSON.dump({:no_trailing_semicolons => { :level => "ignore" }})) }
    results = Coffeelint.lint('apple;', :config_file => "/tmp/coffeelint.json")
    expect(results.length).to eq 0
  end

  it 'should report missing fat arrow' do
    results = Coffeelint.lint "hey: ->\n  @bort()\n", :missing_fat_arrows => { :level => "error" }
    expect(results.length).to eq 1
  end

  it 'should report unnecessary fat arrow' do
    results = Coffeelint.lint "hey: =>\n  bort()\n", :no_unnecessary_fat_arrows => { :level => "error" }
    expect(results.length).to eq 1
  end

  it 'should report cyclomatic complexity' do
    results = Coffeelint.lint(<<-EOF, :cyclomatic_complexity => { :level => "error" })
      x = ->
        1 and 2 and 3 and
        4 and 5 and 6 and
        7 and 8 and 9 and
        10 and 11
    EOF
    expect(results.length).to eq 1
    expect(results[0]['name']).to eq 'cyclomatic_complexity'
  end

  describe 'files to lint' do
    before(:all) do
      FileUtils.mkdir_p('/tmp/coffeelint/subdirectory')
      FileUtils.touch('/tmp/coffeelint/file1.coffee')
      FileUtils.touch('/tmp/coffeelint/file2.coffee')
      FileUtils.touch('/tmp/coffeelint/subdirectory/file3.coffee')
    end

    after(:all) { FileUtils.rm_r('/tmp/coffeelint') }

    before { allow(Coffeelint).to receive(:lint_file) }

    it 'lints all .coffee files in the directory, searching recursively' do
      results = Coffeelint.lint_dir('/tmp/coffeelint')
      expect(results).to include(
        '/tmp/coffeelint/file1.coffee',
        '/tmp/coffeelint/file2.coffee',
        '/tmp/coffeelint/subdirectory/file3.coffee'
      )
    end

    context 'with a .coffeelintignore file' do
      before { File.open('.coffeelintignore', 'w') { |f| f.write("file1.coffee\n*file3.coffee") } }
      after  { FileUtils.rm('.coffeelintignore') }

      it "does not lint ignored paths" do
        results = Coffeelint.lint_dir('/tmp/coffeelint')

        expect(results).to include('/tmp/coffeelint/file2.coffee')
        expect(results).not_to include(
          '/tmp/coffeelint/file1.coffee',
          '/tmp/coffeelint/subdirectory/file3.coffee'
        )
      end
    end
  end
end
