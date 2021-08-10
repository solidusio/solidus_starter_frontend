# frozen_string_literal: true

require 'capybara/apparition'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, window_size: CAPYBARA_WINDOW_SIZE)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by((ENV['CAPYBARA_DRIVER'] || :rack_test).to_sym)
  end

  config.before(:each, type: :system, js: true) do
    driven_by((ENV['CAPYBARA_JS_DRIVER'] || :apparition).to_sym)
  end
end
