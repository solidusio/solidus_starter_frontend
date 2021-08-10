# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

# Create the dummy app if it's still missing.
dummy_env = "#{__dir__}/dummy/config/environment.rb"
system 'bin/rake extension:test_app' unless File.exist? dummy_env
require dummy_env

require 'capybara'

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
