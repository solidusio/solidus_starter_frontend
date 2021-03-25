# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'
require 'solidus_starter_frontend/authentication_helpers'

module SolidusStarterFrontend
  class Engine < Rails::Engine
    isolate_namespace ::Spree

    engine_name 'solidus_starter_frontend'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.to_prepare do
      # TODO: SolidusAuthDevise was adding these methods to ApplicationController.
      # We should check if it's really needed and restore this + add this same
      # include in the generator for who uses the gem copying files into their app.
      # ApplicationController.include SolidusStarterFrontend::AuthenticationHelpers

      Spree::BaseController.unauthorized_redirect = -> do
        if try_spree_current_user
          flash[:error] = I18n.t('spree.authorization_failure')

          redirect_back(fallback_location: spree.unauthorized_path)
        else
          store_location

          redirect_back(fallback_location: spree.login_path)
        end
      end
    end
  end
end
