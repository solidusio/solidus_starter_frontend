
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

add_template_repository_to_source_path

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

run_bundle

# Text updates
append_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += ['solidus_starter_frontend_manifest.js']"
inject_into_file 'config/initializers/spree.rb', "require_relative Rails.root.join('lib/solidus_starter_frontend/config')\n", before: /Spree.config do/, verbose: true
gsub_file 'app/assets/stylesheets/application.css', '*= require_tree', '* OFF require_tree'

# Specs

gem_group :development, :test do
  gem 'apparition', '~> 0.6.0'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-activemodel-mocks', '~> 1.1.0'
  gem 'solidus_dev_support', '~> 2.5'
end

run_bundle

directory 'spec'

generate 'rspec:install'
