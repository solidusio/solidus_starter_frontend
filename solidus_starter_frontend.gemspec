# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "solidus_starter_frontend"
  spec.version = '0.2.0'
  spec.authors = ['Nebulab']
  spec.email = 'hello@nebulab.it'

  spec.summary = 'Cart and storefront for the Solidus e-commerce project.'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/solidusio/solidus_starter_frontend#readme'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio/solidus_starter_frontend'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio/solidus_starter_frontend/commits/main'

  spec.post_install_message = <<~MSG
    -------------------------------------------------------------
                         DEPRECATION NOTICE
    -------------------------------------------------------------
    The solidus_starter_frontend gem has been retired in favor of
    a Rails application template that can be selected directly in
    the Solidus installer with:

      bin/rails generate \
        solidus:install --frontend=solidus_starter_frontend

    Please remove this gem from your gemfile and use the
    generator to copy all the necessary views and controllers to
    your Solidus store.
    -------------------------------------------------------------
  MSG
end
