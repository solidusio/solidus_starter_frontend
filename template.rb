require 'pathname'

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

def install
  add_template_repository_to_source_path

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

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"

    tempdir = Dir.mktmpdir("solidus_starter_frontend-")
    repo_dir = tempdir

    at_exit { FileUtils.remove_entry(tempdir) }

    git clone: [
      "--quiet",
      "https://github.com/nebulab/solidus_starter_frontend.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{solidus_starter_frontend/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    repo_dir = File.dirname(__FILE__)
  end

  templates_dir = Pathname.new(repo_dir).join('templates')

  source_paths.unshift(templates_dir)
end

def copy_files
  directory 'app', 'app', exclude_pattern: exclude_authentication_paths_pattern

  copy_file 'config/initializers/canonical_rails.rb'
  copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb' if include_authentication?
  copy_file 'lib/solidus_starter_frontend_configuration.rb'
  copy_file 'lib/solidus_starter_frontend/config.rb'
end

def copy_routes
  template 'config/routes.rb.tt', 'tmp/routes.rb'
  prepend_file 'config/routes.rb', File.read('tmp/routes.rb')
end

def install_solidus_starter_frontend_gems
  gem 'canonical-rails'
  gem 'solidus_support'
  gem 'truncate_html'

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
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'apparition', '~> 0.6.0'
    gem 'rails-controller-testing', '~> 1.0.5'
    gem 'rspec-activemodel-mocks', '~> 1.1.0'
    gem 'solidus_dev_support', '~> 2.5'
  end

  run_bundle
end

def copy_specs
  directory 'spec', 'spec', exclude_pattern: exclude_authentication_paths_pattern
end

def install_rspec
  generate 'rspec:install'
end

def exclude_authentication_paths_pattern
  return nil if include_authentication?

  @exclude_authentication_paths_pattern ||= Regexp.new(AUTHENTICATION_PATHS.join('|'))
end

def include_authentication?
  File.read('Gemfile').match(/gem ['"]solidus_auth_devise['"]/)
end

def include_specs?
  !ENV['SKIP_SPECS']
end

install
