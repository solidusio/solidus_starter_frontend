# frozen_string_literal: true

require 'bundler'

# `rspec:install` requires these libraries to run.
require 'stringio'
require 'tmpdir'

class SolidusStarterFrontendGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../templates', __dir__)

  def install
    # Copy directories
    directory 'app', 'app'

    # Copy files
    copy_file 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb'
    copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb'
    copy_file 'config/initializers/canonical_rails.rb'

    # Routes
    copy_file 'config/routes.rb', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

    # Gems
    gem 'canonical-rails'
    gem 'solidus_support'
    gem 'truncate_html'

    Bundler.with_original_env do
      run 'bundle install'
    end

    # Text updates
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'

    # Specs
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
