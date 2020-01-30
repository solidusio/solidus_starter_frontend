# Run Coverage report
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/dummy'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Views', 'app/views'
  add_group 'Libraries', 'lib'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rails-controller-testing'
# # require 'rspec/rails'
require 'rspec-activemodel-mocks'
# require 'database_cleaner'
# require 'spree/testing_support/partial_double_verification'
# require 'spree/testing_support/authorization_helpers'
# require 'spree/testing_support/capybara_ext'
# require 'spree/testing_support/factories'
# require 'spree/testing_support/preferences'
# require 'spree/testing_support/controller_requests'
# require 'spree/testing_support/flash'
# require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/caching'

# require 'capybara-screenshot/rspec'
# Capybara.save_path = ENV['CIRCLE_ARTIFACTS'] if ENV['CIRCLE_ARTIFACTS']
# Capybara.default_max_wait_time = ENV['DEFAULT_MAX_WAIT_TIME'].to_f if ENV['DEFAULT_MAX_WAIT_TIME'].present?

require 'solidus_dev_support/rspec/feature_helper'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, headless: false)
end

# Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :selenium_chrome_headless).to_sym

# Requires factories and other useful helpers defined in spree_core.
# require 'solidus_support/extension/feature_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f }

# Requires factories defined in lib/solidus_starter_frontend/factories.rb
# require 'solidus_starter_frontend/factories'

RSpec.configure do |config|
  config.color = true
  config.infer_spec_type_from_file_location!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.fixture_path = File.join(__dir__, "fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    Rails.cache.clear
  end

  config.before(:each, type: :feature) do
    if page.driver.browser.respond_to?(:url_blacklist)
      page.driver.browser.url_blacklist = ['http://fonts.googleapis.com']
    end
  end

  config.after(:each, type: :feature) do |example|
    missing_translations = page.body.scan(/translation missing: #{I18n.locale}\.(.*?)[\s<\"&]/)
    if missing_translations.any?
      puts "Found missing translations: #{missing_translations.inspect}"
      puts "In spec: #{example.location}"
    end
  end

  config.include FactoryBot::Syntax::Methods

  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  # config.include Spree::TestingSupport::Flash

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.example_status_persistence_file_path = "./spec/examples.txt"

  config.order = :random

  Kernel.srand config.seed
end
