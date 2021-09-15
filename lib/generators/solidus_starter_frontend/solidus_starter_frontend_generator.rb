# frozen_string_literal: true

require 'bundler'
require_relative 'enable_code'
require_relative 'disable_code'
require_relative 'remove_markers'

class SolidusStarterFrontendGenerator < Rails::Generators::Base
  PATHS_WITH_AUTHENTICATION_CODE = [
    'app/controllers/spree/checkout_controller.rb',
    'app/views/spree/components/layout/_top_bar.html.erb',
    'config/routes.rb'
  ]

  PATHS_WITH_NON_AUTHENTICATION_CODE = [
    'app/controllers/spree/checkout_controller.rb'
  ]

  AUTHENTICATION_PATHS = [
      'app/controllers/spree/user_confirmations_controller.rb',
      'app/controllers/spree/user_passwords_controller.rb',
      'app/controllers/spree/user_registrations_controller.rb',
      'app/controllers/spree/users_controller.rb',
      'app/controllers/spree/user_sessions_controller.rb',
      'app/decorators/spree/checkout_controller_decorator.rb',
      'app/mailers/spree/user_mailer.rb',
      'app/views/spree/checkout/registration.html.erb',
      'app/views/spree/components/navigation/_auth_link.html.erb',
      'app/views/spree/user_mailer',
      'app/views/spree/user_passwords',
      'app/views/spree/user_registrations',
      'app/views/spree/users',
      'app/views/spree/user_sessions'
    ]

  source_root File.expand_path('../../../templates', __dir__)

  class_option 'skip-specs', type: :boolean, default: false
  class_option 'skip-authentication', type: :boolean, default: false

  def install
    # Copy directories
    directory 'app', 'app', exclude_pattern: exclude_authentication_paths_pattern

    # Copy files
    copy_file 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb'

    # Routes
    template 'config/routes.rb.tt', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

    # Gems
    gem 'canonical-rails'
    gem 'solidus_auth_devise' unless options['skip-authentication']
    gem 'solidus_support'
    gem 'truncate_html'

    Bundler.with_original_env do
      run 'bundle install'
    end

    # Text updates
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'

    # Authentication
    if include_authentication?
      copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb'

      PATHS_WITH_AUTHENTICATION_CODE.each do |path|
        SolidusStarterFrontend::EnableCode.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/with-authentication',
          path: path
        ).call

        SolidusStarterFrontend::RemoveMarkers.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/with-authentication',
          path: path
        ).call
      end

      PATHS_WITH_NON_AUTHENTICATION_CODE.each do |path|
        SolidusStarterFrontend::DisableCode.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/without-authentication',
          path: path
        ).call
      end
    else
      PATHS_WITH_NON_AUTHENTICATION_CODE.each do |path|
        SolidusStarterFrontend::EnableCode.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/without-authentication',
          path: path
        ).call

        SolidusStarterFrontend::RemoveMarkers.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/without-authentication',
          path: path
        ).call
      end

      PATHS_WITH_AUTHENTICATION_CODE.each do |path|
        SolidusStarterFrontend::DisableCode.new(
          generator: self,
          namespace: 'SolidusStarterFrontendGenerator/with-authentication',
          path: path
        ).call
      end
    end

    # Specs
    if include_specs?
      # We can't use Rails' `generate` method here to call the generators. When
      # the solidus_starter_frontend generator is used as a standalone program
      # (instead of added to an app's Gemfile), `generate` won't be able to pick
      # up the other generators that the gem provides.
      #
      # We're able to use Thor's `invoke` action here instead of `generate`.
      # However, `invoke` only works once per generator you want to call. Please
      # see https://stackoverflow.com/a/12029262/65925 for more details.
      #
      # See also https://github.com/nebulab/solidus_starter_frontend/pull/174#discussion_r685626737.
      invoke 'solidus_starter_frontend:rspec', [], 'skip-authentication' => options['skip-authentication']
      invoke 'rspec:install'
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

  def include_specs?
    !options['skip-specs']
  end
end
