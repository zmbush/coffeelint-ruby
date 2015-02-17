require 'json'

module CoffeeLint
  class Config
    # Looks for existing config files and returns the first match.
    def self.locate
      locations = default_locations

      locations << ENV['COFFEELINT_CONFIG'] if ENV['COFFEELINT_CONFIG']

      if ENV['HOME']
        locations << "#{ENV['HOME']}/coffeelint.json"
        locations << "#{ENV['HOME']}/.coffeelint.json"
      end

      locations.compact.detect { |file| File.exists?(file) }
    end

    # Parses a given JSON file to a Hash.
    def self.parse(file_name)
      JSON.parse(File.read(file_name))
    end

    def self.default_locations
      %w(
        coffeelint.json
        .coffeelint.json
        config/coffeelint.json
        config/.coffeelint.json
      )
    end
    private_class_method :default_locations
  end
end
