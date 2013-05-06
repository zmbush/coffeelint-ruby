require 'coffeelint'
require 'rails'
module Coffeelint
  class Railtie < Rails::Railtie
    railtie_name :coffeelint

    rake_tasks do
      load 'tasks/coffeelint.rake'
    end
  end
end
