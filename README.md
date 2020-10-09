# Solidus Starter Frontend
[![Gem Version](https://badge.fury.io/rb/solidus_starter_frontend.svg)](https://badge.fury.io/rb/solidus_starter_frontend) [![CircleCI](https://circleci.com/gh/nebulab/solidus_starter_frontend.svg?style=shield)](https://circleci.com/gh/nebulab/solidus_starter_frontend)

`solidus_starter_frontend` is a new starter store for [Solidus][solidus]. This
extension aims to deliver a modern, minimal, semantic and easy to extend
frontend codebase for a more efficient bootstrapping experience.

## Objectives
We aim to deliver:
- a minimal, semantic and accessible HTML skeleton
- a reusable component based architecture
- simple SASS styling strictly based on BEM
- the elimination of jQuery as a dependency by rewriting frontend functionality
in vanilla JavaScript

All of this while keeping and improving on the functionality of the current
[Solidus][solidus] starter store.

## Installation
By default, the `solidus` gem also includes the standard frontend via
the `solidus_frontend` gem. To make this extension work, you need to
exclude it and manually include all the other Solidus components.

You need to replace:
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

If Solidus was already installed with _solidus_frontend_ you will have to 
replace all the references of the string `Spree::Frontend::Config` in your 
project with `SolidusStarterFrontend::Config`.

You have the following 2 install methods available.

### (1) Copy our components files in your project
With this method, our views, assets, and controllers will be copied over your 
project and you can change easily anything that we created; this gives you a lot
of freedom of customization. On the other hand, you won't be able to auto-update
the storefront code with the next versions released since it will not be present
in your Gemfile.

Installation steps:
```shell
$ cd your/project/
$ gem install solidus_starter_frontend
$ solidus_starter_frontend
```

The last command will copy all the necessary files.

### (2) Add our component as gem in your project
With this method, you simply add our gem to your application and it behaves like
a Rails engine. In this case, our files remain in the gem and you will need to
override the views that you want to customize or if you need different logics to
monkey-patch the classes that we previously defined.

Installation steps:
- add to your _Gemfile_: `gem 'solidus_starter_frontend'`

**IMPORTANT**: put this line before `gem 'solidus_auth_devise'` (if you are 
using this gem) because our component has conditional references to it.

## Development
For information about contributing to this project please refer to this
[document](docs/development.md).

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
