# frozen_string_literal: true

class SolidusStarterFrontendGenerator < Rails::Generators::Base
  source_root File.expand_path('../../..', __dir__)

  def install
    # Copy directories
    directory 'app', 'app'
    directory 'lib/views', 'lib/views'

    # Copy files
    copy_file 'lib/solidus_starter_frontend_configuration.rb', 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb', 'lib/solidus_starter_frontend/config.rb'
    copy_file 'lib/solidus_starter_frontend/solidus_support_extensions.rb', 'lib/solidus_starter_frontend/solidus_support_extensions.rb'

    # Initializer
    initializer 'solidus_starter_frontend.rb' do
      "require 'solidus_starter_frontend/solidus_support_extensions'"
    end

    # Routes
    copy_file 'config/routes.rb', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

    # Gems
    gem 'canonical-rails'
    gem 'solidus_support'
    gem 'truncate_html'

    # Text updates
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'

    invoke 'solidus_starter_frontend:vendor_assets'
  end
end
