def install
  add_template_repository_to_source_path
  install_gems
  copy_solidus_starter_frontend_files
  install_routes
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
  require "shellwords"
  require "securerandom"

  if __FILE__ =~ %r{\Ahttps?://}
    require 'uri'
    url_path = URI.parse(__FILE__).path
    owner = url_path[%r{/([^/]+)/solidus_starter_frontend/}, 1]
    branch = url_path[%r{solidus_starter_frontend/(raw/)?(.+?)/template.rb}, 2]

    repo_source = "https://github.com/#{owner}/solidus_starter_frontend.git"
  else
    branch = nil
    repo_source = "file://#{File.dirname(__FILE__)}"
  end
  repo_dir = Rails.root.join("tmp/solidus_starter_frontend-#{SecureRandom.hex}").tap(&:mkpath).to_s

  git clone: [
    "--quiet",
    "--depth", "1",
    *(["--branch", branch] if branch),
    repo_source,
    repo_dir,
  ].compact.shelljoin

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

    gem 'capybara-screenshot', '~> 1.0'
    gem 'database_cleaner', '~> 1.7'
    gem 'factory_bot', '>= 4.8'
    gem 'factory_bot_rails'
    gem 'ffaker', '~> 2.13'
    gem 'rubocop', '~> 1.0'
    gem 'rubocop-performance', '~> 1.5'
    gem 'rubocop-rails', '~> 2.3'
    gem 'rubocop-rspec', '~> 2.0'
  end
end

def copy_solidus_starter_frontend_files
  directory 'app', 'app'

  copy_file 'config/initializers/solidus_auth_devise_unauthorized_redirect.rb'
  copy_file 'config/initializers/canonical_rails.rb'

  append_file 'config/initializers/devise.rb', <<~RUBY
    Devise.setup do |config|
      config.parent_controller = 'StoreDeviseController'
      config.mailer = 'UserMailer'
    end
  RUBY

  application <<~RUBY
    if defined?(FactoryBotRails)
      initializer after: "factory_bot.set_factory_paths" do
        require 'spree/testing_support'
        FactoryBot.definition_file_paths = [
          *Spree::TestingSupport::FactoryBot.definition_file_paths,
          Rails.root.join('spec/fixtures/factories'),
        ]
      end
    end

  RUBY

  directory 'spec'
  directory 'vendor', force: forcefully_replace_any_solidus_frontend_assets?
end

def install_routes
  route <<~RUBY
    root to: 'home#index'

    devise_for(:user, {
      class_name: 'Spree::User',
      singular: :spree_user,
      controllers: {
        sessions: 'user_sessions',
        registrations: 'user_registrations',
        passwords: 'user_passwords',
        confirmations: 'user_confirmations'
      },
      skip: [:unlocks, :omniauth_callbacks],
      path_names: { sign_out: 'logout' }
    })

    resources :users, only: [:edit, :update]

    devise_scope :spree_user do
      get '/login', to: 'user_sessions#new', as: :login
      post '/login', to: 'user_sessions#create', as: :create_new_session
      match '/logout', to: 'user_sessions#destroy', as: :logout, via: Devise.sign_out_via
      get '/signup', to: 'user_registrations#new', as: :signup
      post '/signup', to: 'user_registrations#create', as: :registration
      get '/password/recover', to: 'user_passwords#new', as: :recover_password
      post '/password/recover', to: 'user_passwords#create', as: :reset_password
      get '/password/change', to: 'user_passwords#edit', as: :edit_password
      put '/password/change', to: 'user_passwords#update', as: :update_password
      get '/confirm', to: 'user_confirmations#show', as: :confirmation if Spree::Auth::Config[:confirmable]
    end

    resource :account, controller: 'users'

    resources :products, only: [:index, :show]

    resources :order_contents, only: :create

    get '/locale/set', to: 'locale#set'
    post '/locale/set', to: 'locale#set', as: :select_locale

    # non-restful checkout stuff
    get '/checkout/registration', to: 'checkout#registration', as: :checkout_registration
    put '/checkout/registration', to: 'checkout#update_registration', as: :update_checkout_registration
    patch '/checkout/update/:state', to: 'checkout#update', as: :update_checkout
    get '/checkout/:state', to: 'checkout#edit', as: :checkout_state
    get '/checkout', to: 'checkout#edit', as: :checkout

    get '/orders/:id/token/:token' => 'orders#show', as: :token_order

    resources :orders, except: [:index, :new, :create, :destroy] do
      resources :coupon_codes, only: :create
    end

    get '/cart', to: 'orders#edit', as: :cart
    patch '/cart', to: 'orders#update', as: :update_cart
    put '/cart/empty', to: 'orders#empty', as: :empty_cart

    # route globbing for pretty nested taxon and product paths
    get '/t/*id', to: 'taxons#show', as: :nested_taxons

    get '/unauthorized', to: 'home#unauthorized', as: :unauthorized
    get '/cart_link', to: 'store#cart_link', as: :cart_link

  RUBY
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
