module SolidusStarterFrontend
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_starter_frontend\n"

        # https://github.com/rails/sprockets/blob/master/UPGRADING.md#manifestjs
        append_file 'app/assets/config/manifest.js', "//= link spree/frontend/all.js\n"
        append_file 'app/assets/config/manifest.js', "//= link spree/frontend/all.css\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_starter_frontend\n", before: /\*\//, verbose: true
      end
    end
  end
end
