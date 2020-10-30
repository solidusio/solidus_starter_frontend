# frozen_string_literal: true

require 'rails-controller-testing'
require 'rspec/active_model/mocks'

require 'spree/testing_support/caching'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/translations' unless Spree.solidus_gem_version < Gem::Version.new('2.11')

RSpec.configure do |config|
  config.include Spree::TestingSupport::Translations unless Spree.solidus_gem_version < Gem::Version.new('2.11')

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
end
