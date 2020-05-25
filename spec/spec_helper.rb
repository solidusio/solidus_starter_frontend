# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'rails-controller-testing'
require 'rspec/active_model/mocks'

# Requires factories and other useful helpers defined in spree_core.
require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/caching'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/translations' unless Spree.solidus_gem_version < Gem::Version.new('2.11')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories defined in lib/solidus_starter_frontend/factories.rb
require 'solidus_starter_frontend/factories'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  if Spree.solidus_gem_version < Gem::Version.new('2.11')
    config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :system

    config.after(:each, type: :system) do |example|
      missing_translations = page.body.scan(/translation missing: #{I18n.locale}\.(.*?)[\s<\"&]/)
      if missing_translations.any?
        puts "Found missing translations: #{missing_translations.inspect}\n"
        puts "In spec: #{example.location}"
      end
    end
  end

  if SolidusSupport.reset_spree_preferences_deprecated?
    config.before :suite do
      Spree::TestingSupport::Preferences.freeze_preferences(SolidusStarterFrontend::Config)
    end
  else
    config.before do
      SolidusStarterFrontend::Config.preference_store = SolidusStarterFrontend::Config.default_preferences
    end
  end

  config.before do
    Rails.cache.clear
  end

  config.before(:each, type: :system) do
    driven_by((ENV['CAPYBARA_DRIVER'] || :rack_test).to_sym)
  end

  config.before(:each, type: :system, js: true) do
    driven_by((ENV['CAPYBARA_JS_DRIVER'] || :apparition).to_sym)
  end
end
