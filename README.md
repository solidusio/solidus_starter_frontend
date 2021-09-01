# Solidus Starter Frontend
[![Gem Version](https://badge.fury.io/rb/solidus_starter_frontend.svg)](https://badge.fury.io/rb/solidus_starter_frontend) [![CircleCI](https://circleci.com/gh/nebulab/solidus_starter_frontend.svg?style=shield)](https://circleci.com/gh/nebulab/solidus_starter_frontend)

`solidus_starter_frontend` is a new starter storefront for [Solidus][solidus].

This project aims to deliver a modern, minimal, semantic, and easy to extend
codebase for a more efficient bootstrapping experience.

**DISCLAIMER**: some Solidus extensions (the ones that depend on Solidus
Frontend) will not work with this project because they rely on defacing some
views items that don't exist here.

## Objectives
We aim to deliver:
- a minimal, semantic and accessible HTML skeleton
- a reusable component based architecture
- simple SASS styling strictly based on BEM
- the elimination of jQuery as a dependency by rewriting frontend functionality
in vanilla JavaScript

All of this while keeping and improving on the functionality of the current
[Solidus][solidus] frontend subcomponent.

## Installation

By default, the `solidus` gem also includes the standard frontend via the
`solidus_frontend` gem. To make this gem work, you need to exclude
`solidus_frontend` gem and manually include the rest of the Solidus
components.

### For a new store

Just run:

```bash
rails new store --skip-javascript
cd store
bundle add solidus_core solidus_backend solidus_api solidus_sample
bundle add rspec-rails --group 'development, test'
bin/rails generate solidus:install --auto-accept
```

Please note that `--auto-accept` will add [Solidus Auth Devise]
(https://github.com/solidusio/solidus_auth_devise) to your application. At the
moment, SolidusStarterFrontend requires the application to include the gem. In
the future, we'll make Solidus Auth Devise optional.

`rspec-rails` is required to install the frontend's test suite to your app. If
you'd like to exclude the gem, you'll need to specify `--skip-specs` when you
run `solidus_starter_frontend` later.

### For existing stores

In your `Gemfile` replace:

```ruby
gem 'solidus'
```

with:

```ruby
gem 'solidus_core'
gem 'solidus_api'
gem 'solidus_backend'
gem 'solidus_sample'
```

And replace all the references of the string `Spree::Frontend::Config` in your
project with `SolidusStarterFrontend::Config`.

You'll also need to make sure that [Solidus Auth Devise]
(https://github.com/solidusio/solidus_auth_devise) is installed in your
application.

Finally, please note that `rspec-rails` is required to install
the frontend's test suite to your app. If you'd like to exclude the gem, you'll
need to specify `--skip-specs` when you run `solidus_starter_frontend` later.

### Frontend installation

You can copy the starter frontend files to your project:

```shell
$ gem install solidus_starter_frontend
$ solidus_starter_frontend
```

These commands will install the gem globally and copy this project's views,
assets, routes, controllers, and specs to your project. You can change easily
anything that we created; this gives you a lot of freedom of customization.

You can choose to exclude the RSpec test suite by running
`solidus_starter_frontend --skip-specs`.

In addition, please note that the command will add Solidus Auth Devise
frontend components to your app. At the moment, you will need to manually
remove the gem and its frontend components if you don't need them.

Finally, please note that you won't be able to auto-update the storefront code
with the next versions released since this project's gem will not be present in
your Gemfile.

## Development

For information about contributing to this project please refer to this
[document](docs/development.md). There you'll find information on tasks like:

* Testing the extension
* Running the sandbox
* Updating the changelog
* Releasing new versions
* Docker development

## About
[![Nebulab][nebulab-logo]][nebulab]

`solidus_starter_frontend` is funded and maintained by the [Nebulab][nebulab]
team.

We firmly believe in the power of open-source. [Contact us][contact-us] if you
like our work and you need help with your project design or development.

[solidus]: http://solidus.io/
[nebulab]: http://nebulab.it/
[nebulab-logo]: http://nebulab.it/assets/images/public/logo.svg
[contact-us]: http://nebulab.it/contact-us/

## License
Copyright (c) 2020 Nebulab SRLs, released under the New BSD License.
