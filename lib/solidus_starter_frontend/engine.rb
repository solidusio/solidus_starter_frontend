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

    config.to_prepare do
      if defined?(Spree::Auth::Engine)
        [
          Spree::UserConfirmationsController,
          Spree::UserPasswordsController,
          Spree::UserRegistrationsController,
          Spree::UserSessionsController,
          Spree::UsersController
        ].each do |auth_controller|
          auth_controller.include SolidusStarterFrontend::Taxonomies
        end
      end
    end
  end
end
