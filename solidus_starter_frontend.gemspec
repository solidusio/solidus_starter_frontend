# frozen_string_literal: true

require_relative 'lib/solidus_starter_frontend/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_starter_frontend'
  spec.version = SolidusStarterFrontend::VERSION
  spec.authors = ['Nebulab']
  spec.email = 'hello@nebulab.it'

  spec.summary = 'Cart and storefront for the Solidus e-commerce project.'
  spec.description = spec.summary
  spec.homepage = 'https://www.nebulab.it'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://www.nebulab.it'
  # spec.metadata['changelog_uri'] = ''

  spec.required_ruby_version = Gem::Requirement.new('~> 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'canonical-rails', '~> 0.2.0'
  spec.add_dependency 'generator_spec'
  spec.add_dependency 'solidus_api', ['>= 2.0', '< 3']
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  spec.add_dependency 'solidus_support', '~> 0.5'
  spec.add_dependency 'truncate_html', '~> 0.9', '>= 0.9.2'

  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'rspec-activemodel-mocks'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'solidus_dev_support', '~> 2.0'
end
