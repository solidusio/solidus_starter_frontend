# frozen_string_literal: true

require 'bundler'

# `rspec:install` requires these libraries to run.
require 'stringio'
require 'tmpdir'

class SolidusStarterFrontendGenerator < Rails::Generators::Base
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
      'app/views/spree/user_sessions',
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

  class_option 'skip-specs', type: :boolean, default: false

  def install
    copy_files
    copy_routes
    install_solidus_starter_frontend_gems
    update_asset_files
    require_solidus_starter_frontend_config

    if include_specs?
      install_spec_gems
      copy_specs
      install_rspec
    end
  end

  private

  def copy_files
    directory 'app', 'app', exclude_pattern: exclude_authentication_paths_pattern

    copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb' if include_authentication?
    copy_file 'lib/solidus_starter_frontend_configuration.rb'
    copy_file 'lib/solidus_starter_frontend/config.rb'
  end

  def copy_routes
    template 'config/routes.rb.tt', 'tmp/routes.rb'
    prepend_file 'config/routes.rb', File.read('tmp/routes.rb')
  end

  def install_solidus_starter_frontend_gems
    append_gemfile_partial '080_solidus_starter_frontend_dependencies.rb'

    run_bundle
  end

  def update_asset_files
    append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
    gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'
  end

  def require_solidus_starter_frontend_config
    inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
  end

  def install_spec_gems
    append_gemfile_partial '110_solidus_starter_frontend_rspec_dependencies.rb'

    run_bundle
  end

  def copy_specs
    directory 'spec', 'spec', exclude_pattern: exclude_authentication_paths_pattern
  end

  def install_rspec
    invoke 'rspec:install'
  end

  def append_gemfile_partial(filename)
    copy_file "gemfiles/#{filename}", "tmp/#{filename}"
    append_to_file 'Gemfile', File.read("tmp/#{filename}")
  end

  def run_bundle
    Bundler.with_original_env do
      run 'bundle install'
    end
  end

  def exclude_authentication_paths_pattern
    return nil if include_authentication?

    @exclude_authentication_paths_pattern ||= Regexp.new(AUTHENTICATION_PATHS.join('|'))
  end

  def include_authentication?
    File.read('Gemfile').match(/gem ['"]solidus_auth_devise['"]/)
  end

  def include_specs?
    !options['skip-specs']
  end
end
