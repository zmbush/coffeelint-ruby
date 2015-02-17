require 'spec_helper'

module CoffeeLint
  describe Config do
    describe '.locate' do
      before(:each) { allow(File).to receive(:exists?) { false } }

      it 'returns nil if no config file could be located' do
        expect(Config.locate).to eq(nil)
      end

      context 'default locations' do
        %w(coffeelint.json .coffeelint.json config/coffeelint.json config/.coffeelint.json).each do |config_file|
          it "tries to locate #{config_file}" do
            allow(File).to receive(:exists?).with(config_file).and_return(true)
            expect(Config.locate).to eq(config_file)
          end
        end
      end

      context 'environment variables' do
        it 'tries to locate ENV[\'COFFEELINT_CONFIG\']' do
          ENV['COFFEELINT_CONFIG'] = 'coffeelint.json'

          allow(File).to receive(:exists?).with('coffeelint.json').and_return(true)
          expect(Config.locate).to eq('coffeelint.json')
        end

        it 'tries to locate ENV[\'HOME\']' do
          ENV['HOME'] = 'coffeelint.json'

          allow(File).to receive(:exists?).with('coffeelint.json').and_return(true)
          expect(Config.locate).to eq('coffeelint.json')
        end
      end
    end

    describe '.parse' do
      it 'should parse a given JSON file' do
        expect(Config.parse(File.join(File.dirname(__FILE__), 'assets/.coffeelint.json'))).
          to eq({"max_line_length" => {"value" => 120}})
      end
    end
  end
end
