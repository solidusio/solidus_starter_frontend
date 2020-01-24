# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')

gem 'solidus_core', github: 'solidusio/solidus', branch: branch
gem 'solidus_api', github: 'solidusio/solidus', branch: branch
gem 'solidus_backend', github: 'solidusio/solidus', branch: branch
gem 'solidus_sample', github: 'solidusio/solidus', branch: branch

# Provides basic authentication functionality for testing parts of your engine
gem 'solidus_auth_devise'

gem 'factory_bot', '> 4.10.0'

if ENV['DB'] == 'mysql'
  gem 'mysql2', '~> 0.4.10'
else
  gem 'pg', '~> 0.21'
end

gemspec
