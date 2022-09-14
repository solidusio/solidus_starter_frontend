# frozen_string_literal: true

require 'rails_helper'

require 'rails-controller-testing'
require 'rspec/active_model/mocks'

require "view_component/test_helpers"

# Requires factories and other useful helpers defined in spree_core.
# START require 'solidus_dev_support/rspec/feature_helper'
RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec
  config.color = true

  config.fail_fast = ENV.fetch('FAIL_FAST', false)
  config.order = 'random'

  config.raise_errors_for_deprecations!

  config.example_status_persistence_file_path = "./spec/examples.txt"

  Kernel.srand config.seed
end
require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot'
require 'ffaker'

require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::TestingSupport::UrlHelpers

  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  config.include Spree::TestingSupport::Preferences

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    ActiveJob::Base.queue_adapter = :test
  end

  # Around each spec check if it is a Javascript test and switch between using
  # database transactions or not where necessary.
  config.around(:each) do |example|
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.cleaning { example.run }
  end

  config.include ActiveJob::TestHelper

  config.after(:suite) do
    if Rails.respond_to?(:autoloaders) && Rails.autoloaders.zeitwerk_enabled?
      Rails.autoloaders.main.class.eager_load_all
    end
  rescue NameError => e
    class ZeitwerkNameError < NameError; end

    error_message =
      if e.message =~ /expected file .*? to define constant [\w:]+/
        e.message.sub(/expected file #{Regexp.escape(File.expand_path('../..', Rails.root))}./, "expected file ")
      else
        e.message
      end

    message = <<~WARN
      Zeitwerk raised the following error when trying to eager load your extension:

      #{error_message}

      This most likely means that your extension's file structure is not
      compatible with the Zeitwerk autoloader.
      Refer to https://github.com/solidusio/solidus_support#engine-extensions in
      order to update the file structure to match Zeitwerk's expectations.
    WARN

    raise ZeitwerkNameError, message
  end
end

# END require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/caching'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/translations'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{__dir__}/support/solidus_starter_frontend/**/*.rb"].sort.each { |f| require f }

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
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

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
