# frozen_string_literal: true

require_relative 'enable_code'
require_relative 'disable_code'
require_relative 'remove_markers'

module SolidusStarterFrontend
  class RspecGenerator < Rails::Generators::Base
    PATHS_WITH_AUTHENTICATION_CODE = [
      'spec/controllers/controller_helpers_spec.rb',
      'spec/requests/spree/orders_ability_spec.rb',
      'spec/solidus_starter_frontend_helper.rb',
      'spec/support/solidus_starter_frontend/system_helpers.rb',
      'spec/system/checkout_spec.rb'
    ]

    PATHS_WITH_NON_AUTHENTICATION_CODE = [
      'spec/solidus_starter_frontend_helper.rb',
      'spec/requests/spree/orders_ability_spec.rb',
      'spec/system/checkout_spec.rb'
    ]

    AUTHENTICATION_PATHS = [
      'spec/controllers/spree/base_controller_spec.rb',
      'spec/controllers/spree/checkout_controller_spec.rb',
      'spec/controllers/spree/products_controller_spec.rb',
      'spec/controllers/spree/user_passwords_controller_spec.rb',
      'spec/controllers/spree/user_registrations_controller_spec.rb',
      'spec/controllers/spree/users_controller_spec.rb',
      'spec/controllers/spree/user_sessions_controller_spec.rb',
      'spec/mailers/user_mailer_spec.rb',
      'spec/support/solidus_starter_frontend/features/fill_addresses_fields.rb',
      'spec/system/authentication'
    ]

    source_root File.expand_path('../../..', __dir__)

    class_option 'skip-authentication', type: :boolean, default: false

    def install
      gem_group :development, :test do
        gem 'apparition', '~> 0.6.0'
        gem 'rails-controller-testing', '~> 1.0.5'
        gem 'rspec-activemodel-mocks', '~> 1.1.0'
        gem 'solidus_dev_support', '~> 2.5'
      end

      Bundler.with_original_env do
        run 'bundle install'
      end

      # Copy spec files
      directory 'spec/controllers', exclude_pattern: exclude_authentication_paths_pattern
      directory 'spec/helpers'
      directory 'spec/mailers', exclude_pattern: exclude_authentication_paths_pattern
      directory 'spec/requests'
      directory 'spec/support/solidus_starter_frontend', exclude_pattern: exclude_authentication_paths_pattern
      directory 'spec/system', exclude_pattern: exclude_authentication_paths_pattern
      directory 'spec/views'
      copy_file 'spec/solidus_starter_frontend_helper.rb'

      if include_authentication?
        PATHS_WITH_AUTHENTICATION_CODE.each do |path|
          SolidusStarterFrontend::EnableCode.new(
            generator: self,
            namespace: 'RspecGenerator/with-authentication',
            path: path
          ).call

          SolidusStarterFrontend::RemoveMarkers.new(
            generator: self,
            namespace: 'RspecGenerator/with-authentication',
            path: path
          ).call
        end

        PATHS_WITH_NON_AUTHENTICATION_CODE.each do |path|
          SolidusStarterFrontend::DisableCode.new(
            generator: self,
            namespace: 'RspecGenerator/without-authentication',
            path: path
          ).call
        end
      else
        PATHS_WITH_NON_AUTHENTICATION_CODE.each do |path|
          SolidusStarterFrontend::EnableCode.new(
            generator: self,
            namespace: 'RspecGenerator/without-authentication',
            path: path
          ).call

          SolidusStarterFrontend::RemoveMarkers.new(
            generator: self,
            namespace: 'RspecGenerator/without-authentication',
            path: path
          ).call
        end

        PATHS_WITH_AUTHENTICATION_CODE.each do |path|
          SolidusStarterFrontend::DisableCode.new(
            generator: self,
            namespace: 'RspecGenerator/with-authentication',
            path: path
          ).call
        end
      end
    end

    private

    def include_authentication?
      !options['skip-authentication']
    end

    def exclude_authentication_paths_pattern
      @exclude_authentication_paths_pattern ||=
        options['skip-authentication'] ? Regexp.new(AUTHENTICATION_PATHS.join('|')) : nil
    end
  end
end
