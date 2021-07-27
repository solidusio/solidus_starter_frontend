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

      Spree::BaseController.unauthorized_redirect = -> do
        if try_spree_current_user
          flash[:error] = I18n.t('spree.authorization_failure')

          if Spree::Auth::Engine.redirect_back_on_unauthorized?
            redirect_back(fallback_location: spree.unauthorized_path)
          else
            redirect_to spree.unauthorized_path
          end
        else
          store_location

          if Spree::Auth::Engine.redirect_back_on_unauthorized?
            redirect_back(fallback_location: spree.login_path)
          else
            redirect_to spree.login_path
          end
        end
      end
    end
  end
end
