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

    config.after_initialize do
      if defined?(Spree::Auth::Engine)
        [
          Spree::UserConfirmationsController,
          Spree::UserPasswordsController,
          Spree::UserRegistrationsController,
          Spree::UserSessionsController,
          Spree::UsersController
        ].each do |auth_controller|
          auth_controller.include SolidusStarterFrontend::Taxonomies
          auth_controller.include SolidusStarterFrontend::AuthViews
        end

        Spree::StoreController.include SolidusStarterFrontend::AuthViews
      end
    end
  end
end
