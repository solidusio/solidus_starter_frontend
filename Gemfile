# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '>0.a'

# By default, the solidus gem also includes the standard frontend via
# the solidus_frontend gem. To make this extension work, you need to
# exclude it and manually include all the other Solidus components.

solidus_repo = ENV.fetch('SOLIDUS_REPO', 'solidusio/solidus')
solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'master')

gem 'solidus_core', github: solidus_repo, branch: solidus_branch
gem 'solidus_api', github: solidus_repo, branch: solidus_branch
gem 'solidus_backend', github: solidus_repo, branch: solidus_branch
gem 'solidus_sample', github: solidus_repo, branch: solidus_branch

gem 'rails-i18n'

solidus_i18n_repo = ENV.fetch('SOLIDUS_I18N_REPO', 'solidusio/solidus_i18n')
solidus_i18n_branch = ENV.fetch('SOLIDUS_I18N_BRANCH', 'master')

gem 'solidus_i18n', github: solidus_i18n_repo, branch: solidus_i18n_branch

gem 'solidus_auth_devise'

gem 'canonical-rails'
gem 'solidus_support'
gem 'truncate_html'

group :development, :test do
  gem 'rspec-rails'
  gem 'apparition', '~> 0.6.0'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-activemodel-mocks', '~> 1.1.0'
  gem 'solidus_dev_support', '~> 2.5'
end
