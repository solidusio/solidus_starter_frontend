# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_starter_frontend/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_starter_frontend'
  s.version     = SolidusStarterFrontend::VERSION
  s.summary     = 'Cart and storefront for the Solidus e-commerce project.'
  s.description = 'Placeholder description.'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Nebulab'
  s.email     = 'hello@nebulab.it'
  s.homepage  = 'https://www.nebulab.it'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'solidus_api'
  s.add_dependency 'solidus_core'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'gem-release'
end
