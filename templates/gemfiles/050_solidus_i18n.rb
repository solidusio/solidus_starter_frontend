gem 'rails-i18n'

solidus_i18n_repo = ENV.fetch('SOLIDUS_I18N_REPO', 'solidusio/solidus_i18n')
solidus_i18n_branch = ENV.fetch('SOLIDUS_I18N_BRANCH', 'master')

gem 'solidus_i18n', github: solidus_i18n_repo, branch: solidus_i18n_branch
