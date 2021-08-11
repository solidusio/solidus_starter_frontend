# frozen_string_literal: true

module SolidusStarterFrontend
  class RspecGenerator < Rails::Generators::Base
    source_root File.expand_path('../../..', __dir__)

    def install
      # solidus_dev_support 2.5.0 depends on this puma version.
      gsub_file 'Gemfile', /gem ['"]puma['"].*/, "# gem 'puma' # solidus_dev_support 2.5.0 depends on puma ~> 4.3. See puma declaration below."
      gem 'puma', '~> 4.3'

      gem_group :development, :test do
        gem 'apparition', '~> 0.6.0'
        gem 'rails-controller-testing', '~> 1.0.5'
        gem 'rspec-activemodel-mocks', '~> 1.1.0'
        gem 'solidus_dev_support', '~> 2.0'
      end

      # Copy spec files
      directory 'spec/controllers'
      directory 'spec/helpers'
      directory 'spec/mailers'
      directory 'spec/requests'
      directory 'spec/support/solidus_starter_frontend'
      directory 'spec/system'
      directory 'spec/views'
      copy_file 'spec/solidus_starter_frontend_helper.rb'
    end
  end
end
