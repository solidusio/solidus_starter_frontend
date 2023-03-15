# frozen_string_literal: true

require 'selenium/webdriver'
require 'webdrivers'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'spree/testing_support/capybara_ext'

Capybara.default_max_wait_time = 10

# Fix a selenium deprecation warning.
# Ref: https://github.com/rails/rails/pull/47117
require 'action_dispatch/system_testing/driver'
ActionDispatch::SystemTesting::Driver.class_eval do
  def browser_options
    @options.merge(options: @browser.options).compact
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by((ENV['CAPYBARA_DRIVER'] || :rack_test).to_sym)
  end

  config.before(:each, type: :system, js: true) do
    driven_by((ENV['CAPYBARA_JS_DRIVER'] || :selenium_chrome_headless).to_sym)
  end
end

Capybara.register_driver :selenium_chrome_headless_docker_friendly do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  # Sandbox cannot be used inside unprivileged Docker container
  browser_options.args << '--no-sandbox'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
