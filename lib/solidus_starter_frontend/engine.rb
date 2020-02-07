# frozen_string_literal: true

module SolidusStarterFrontend
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_starter_frontend'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
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

    config.to_prepare(&method(:activate).to_proc)
  end
end
