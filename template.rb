def install
  add_template_repository_to_source_path
  install_gems
  copy_solidus_starter_frontend_files
  update_asset_files
  install_rspec
  print_security_update_message
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
      "https://github.com/solidusio/solidus_starter_frontend.git",
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

def install_gems
  add_solidus_auth_devise_if_missing
  add_solidus_starter_frontend_dependencies
  add_solidus_starter_frontend_spec_dependencies

  run_bundle
end

def add_solidus_auth_devise_if_missing
  unless Bundler.locked_gems.dependencies['solidus_auth_devise']
    bundle_command 'add solidus_auth_devise'
    generate 'solidus:auth:install'
  end
end

def add_solidus_starter_frontend_dependencies
  gem 'canonical-rails'
  gem 'solidus_support'
  gem 'truncate_html'
  gem 'view_component', '~> 2.46'
end

def add_solidus_starter_frontend_spec_dependencies
  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'apparition', '~> 0.6.0', github: 'twalpole/apparition'
    gem 'rails-controller-testing', '~> 1.0.5'
    gem 'rspec-activemodel-mocks', '~> 1.1.0'
    gem 'solidus_dev_support', '~> 2.5'
  end
end

def copy_solidus_starter_frontend_files
  directory 'app', 'app'

  copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb'
  copy_file 'config/initializers/canonical_rails.rb'

  copy_file 'config/routes.rb', 'tmp/routes.rb'
  prepend_file 'config/routes.rb', File.read('tmp/routes.rb')

  directory 'spec'
  directory 'vendor', force: forcefully_replace_any_solidus_frontend_assets?
end

# In CI, the Rails environment is test. In that Rails environment,
# `Solidus::InstallGenerator#setup_assets` adds `solidus_frontend` assets to
# vendor. We'd want to forcefully replace those `solidus_frontend` assets with
# SolidusStarterFrontend assets in CI.
def forcefully_replace_any_solidus_frontend_assets?
  Rails.env.test?
end

def update_asset_files
  append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
  gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'
end

def install_rspec
  generate 'rspec:install'
end

def print_security_update_message
  message = <<~TEXT
    RECOMMENDED: To receive security announcements concerning Solidus Starter
    Frontend, please subscribe to the Solidus Security mailing list
    (https://groups.google.com/forum/#!forum/solidus-security). The mailing
    list is very low traffic, and it receives the public notifications the
    moment the vulnerability is published. For more information, please check
    out https://solidus.io/security.
  TEXT

  print_wrapped set_color(message.gsub("\n", ' '), :yellow)
end

install
