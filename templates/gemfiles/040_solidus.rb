# By default, the solidus gem also includes the standard frontend via
# the solidus_frontend gem. To make this extension work, you need to
# exclude it and manually include all the other Solidus components.

solidus_repo = ENV.fetch('SOLIDUS_REPO', 'solidusio/solidus')
solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'master')

gem 'solidus_core', github: solidus_repo, branch: solidus_branch
gem 'solidus_api', github: solidus_repo, branch: solidus_branch
gem 'solidus_backend', github: solidus_repo, branch: solidus_branch
gem 'solidus_sample', github: solidus_repo, branch: solidus_branch
