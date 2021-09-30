# frozen_string_literal: true

require 'capybara/apparition'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, window_size: CAPYBARA_WINDOW_SIZE)
end

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
  config.before(:each, type: :system) do
    driven_by((ENV['CAPYBARA_DRIVER'] || :rack_test).to_sym)
  end

  config.before(:each, type: :system, js: true) do
    driven_by((ENV['CAPYBARA_JS_DRIVER'] || :apparition).to_sym)
  end
end
