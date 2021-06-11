# frozen_string_literal: true

class SolidusStarterFrontendGenerator < Rails::Generators::Base
  source_root File.expand_path('../../..', __dir__)

  def install
    # Copy directories
    directory 'app', 'app', exclude_pattern: /auth_views/
    directory 'lib/views/auth', 'app/views'

    # Copy files
    copy_file 'lib/solidus_starter_frontend_configuration.rb', 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb', 'lib/solidus_starter_frontend/config.rb'

    # Routes
    copy_file 'config/routes.rb', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

    # Enable Solidus frontend
    application do
      <<~RUBY
        config.x.solidus.frontend_available = true
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
        RUBY
    end

    # Gems
    gem 'canonical-rails'
    gem 'truncate_html'

    # Text updates
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_starter_frontend\n"
    inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_starter_frontend\n", before: %r{\*/}, verbose: true
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'
  end
end
