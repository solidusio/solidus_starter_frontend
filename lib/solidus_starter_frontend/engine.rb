# frozen_string_literal: true

require 'spree/core'
require 'solidus_starter_frontend'

module SolidusStarterFrontend
  class Engine < Rails::Engine
    isolate_namespace ::Spree

    engine_name 'solidus_starter_frontend'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
