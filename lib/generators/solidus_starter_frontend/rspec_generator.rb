# frozen_string_literal: true

module SolidusStarterFrontend
  class RspecGenerator < Rails::Generators::Base
    AUTHENTICATION_PATHS = [
      'spec/controllers/spree/base_controller_spec.rb',
      'spec/controllers/spree/checkout_controller_spec.rb',
      'spec/controllers/spree/products_controller_spec.rb',
      'spec/controllers/spree/user_passwords_controller_spec.rb',
      'spec/controllers/spree/user_registrations_controller_spec.rb',
      'spec/controllers/spree/users_controller_spec.rb',
      'spec/controllers/spree/user_sessions_controller_spec.rb',
      'spec/mailers/user_mailer_spec.rb',
      'spec/support/solidus_starter_frontend/features/fill_addresses_fields.rb',
      'spec/system/authentication'
    ]

    source_root File.expand_path('../../../templates', __dir__)

    class_option 'skip-authentication', type: :boolean, default: false

    def install
      install_spec_gems
      copy_specs
    end

    private

    def install_spec_gems
      append_gemfile_partial '110_solidus_starter_frontend_rspec_dependencies.rb'

      run_bundle
    end

    def run_bundle
      Bundler.with_original_env do
        run 'bundle install'
      end
    end

    def copy_specs
      directory 'spec', 'spec', exclude_pattern: exclude_authentication_paths_pattern
    end

    def append_gemfile_partial(filename)
      copy_file "gemfiles/#{filename}", "tmp/#{filename}"
      append_to_file 'Gemfile', File.read("tmp/#{filename}")
    end

    def include_authentication?
      !options['skip-authentication']
    end

    def exclude_authentication_paths_pattern
      @exclude_authentication_paths_pattern ||=
        options['skip-authentication'] ? Regexp.new(AUTHENTICATION_PATHS.join('|')) : nil
    end
  end
end
