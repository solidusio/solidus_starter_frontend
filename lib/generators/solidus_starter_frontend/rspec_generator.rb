# frozen_string_literal: true

module SolidusStarterFrontend
  class RspecGenerator < Rails::Generators::Base
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

    source_root File.expand_path('../../../templates', __dir__)

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
      template 'spec/solidus_starter_frontend_helper.rb.tt'
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
