# frozen_string_literal: true

class SolidusStarterFrontendGenerator < Rails::Generators::Base
  source_root File.expand_path('../../..', __dir__)

  class_option 'skip-specs', type: :boolean, default: false

  def install
    # Copy directories
    directory 'app', 'app'

    # Copy files
    copy_file 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb'
    copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb'

    # Routes
    copy_file 'config/routes.rb', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

    # Gems
    gem 'canonical-rails'
    gem 'solidus_auth_devise'
    gem 'solidus_support'
    gem 'truncate_html'

    # Text updates
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_starter_frontend\n"
    inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_starter_frontend\n", before: %r{\*/}, verbose: true
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'

    unless options['skip-specs']
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
      invoke 'solidus_starter_frontend:rspec'
      invoke 'rspec:install'
    end
  end
end
