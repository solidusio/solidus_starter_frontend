# solidus_starter_frontend

`solidus_starter_frontend` is a new starter store for [Solidus][solidus]. This
extension aims to deliver a modern, minimal, semantic and easy to extend
frontend codebase for a more efficient bootstrapping experience.

**WARNING: this is an experimental extension and still in a very early stage of
development.**

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
exclude it and manually include all the other Solidus componenents.

You need to replace:

```
gem 'solidus'
```

with:

```
gem 'solidus_core'
gem 'solidus_api'
gem 'solidus_backend'
gem 'solidus_sample'
gem "solidus_starter_frontend"
```

If Solidus was already installed, you have to run:

```
bundle
bundle exec rails g solidus_starter_frontend:install
```

and change all `Spree::Frontend::Config` in `SolidusStarterFrontend::Config`.

If it's the first Solidus installation you need to run the Solidus install
before `bundle exec rails g solidus_starter_frontend:install`.
Please, take a look at the [Solidus README](https://github.com/solidusio/solidus#installation-options).

## Customization

In order to customize a view you should copy the file into your host app.
Using Deface is not recommended as it provides lots of headaches while
debugging and degrades your shops performance.

Solidus provides a generator to help with copying the right view into your host
app.

Simply call the generator to copy all views into your host app:
```bash
$ bundle exec rails g solidus:views:override
```

If you only want to copy certain views into your host app, you can provide the
`--only` argument:
```bash
$ bundle exec rails g solidus:views:override --only products/show
```

The argument to `--only` can also be a substring of the name of the view from
the `app/views/spree` folder:
```bash
$ bundle exec rails g solidus:views:override --only product
```

## About

[![Nebulab][nebulab-logo]][nebulab]

`solidus_starter_frontend` is funded and maintained by the [Nebulab][nebulab] team.

We firmly believe in the power of open-source. [Contact us][contact-us] if you
like our work and you need help with your project design or development.

[solidus]: http://solidus.io/
[nebulab]: http://nebulab.it/
[nebulab-logo]: http://nebulab.it/assets/images/public/logo.svg
[contact-us]: http://nebulab.it/contact-us/
