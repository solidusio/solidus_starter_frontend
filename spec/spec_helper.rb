# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

require 'rails-controller-testing'
require 'rspec/active_model/mocks'

# Create the dummy app if it's still missing.
dummy_env = "#{__dir__}/dummy/config/environment.rb"
system 'bin/rake extension:test_app' unless File.exist? dummy_env
require dummy_env

# Requires factories and other useful helpers defined in spree_core.
require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/caching'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/translations' unless Spree.solidus_gem_version < Gem::Version.new('2.11')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

Capybara.register_driver :apparition_docker_friendly do |app|
  opts = {
    headless: true,
    browser_options: [
      :no_sandbox,
      :disable_gpu,
      { disable_features: 'VizDisplayCompositor' }
    ]
  }
  Capybara::Apparition::Driver.new(app, opts)
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  # We currently have examples wherein we mock or stub method that do not exist on
  # the real objects.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end

  if Spree.solidus_gem_version < Gem::Version.new('2.11')
    config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :system
  else
    config.include Spree::TestingSupport::Translations
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.before(:each, with_signed_in_user: true) do
    sign_in(user)
  end

  config.before(:each, with_guest_session: true) do
    allow_any_instance_of(ActionDispatch::Cookies::CookieJar).to receive(:signed) { { guest_token: order.guest_token } }
  end

  config.around(:each, caching: true) do |example|
    original_cache_store = ActionController::Base.cache_store
    ActionController::Base.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)

    example.run

    ActionController::Base.cache_store = original_cache_store
  end
end
