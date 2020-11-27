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

require 'spree/testing_support/factory_bot'
FactoryBot.definition_file_paths = Spree::TestingSupport::FactoryBot.definition_file_paths
FactoryBot.reload

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  if Spree.solidus_gem_version < Gem::Version.new('2.11')
    config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :system
  else
    config.include Spree::TestingSupport::Translations
  end

  config.before(:each, with_signed_in_user: true) do
    Spree::StoreController.define_method(:spree_current_user) do
      Spree.user_class.find_by(spree_api_key: 'fake api key')
    end

    allow(Spree.user_class).to receive(:find_by)
      .with(hash_including(:spree_api_key))
      .and_return(user)
  end

  config.before(:each, with_guest_session: true) do
    allow_any_instance_of(ActionDispatch::Cookies::CookieJar).to receive(:signed) { { guest_token: order.guest_token } }
  end
end
