# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

solidus_repo = ENV.fetch('SOLIDUS_REPO', 'solidusio/solidus')
solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
solidus_i18n_repo = ENV.fetch('SOLIDUS_I18N_REPO', 'solidusio/solidus_i18n')
solidus_i18n_branch = ENV.fetch('SOLIDUS_I18N_BRANCH', 'master')
gem 'solidus_core', github: solidus_repo, branch: solidus_branch
gem 'solidus_api', github: solidus_repo, branch: solidus_branch
gem 'solidus_backend', github: solidus_repo, branch: solidus_branch
gem 'solidus_sample', github: solidus_repo, branch: solidus_branch
gem 'solidus_i18n', github: solidus_i18n_repo, branch: solidus_i18n_branch

gem 'rails'

gem 'mysql2' if ENV['DB'] == 'mysql' || ENV['DB_ALL']

gem 'pg' if ENV['DB'] == 'postgresql' || ENV['DB_ALL']

gem 'sqlite3' if !%w[mysql postgresql].include?(ENV['DB']) || ENV['DB_ALL']

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g. pry-byebug.
#
# We use `send` instead of calling `eval_gemfile` to work around an issue with
# how Dependabot parses projects: https://github.com/dependabot/dependabot-core/issues/1658.
send(:eval_gemfile, 'Gemfile-local') if File.exist? 'Gemfile-local'
