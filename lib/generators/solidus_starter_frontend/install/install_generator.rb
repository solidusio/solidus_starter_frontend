# frozen_string_literal: true

require_relative '../vendor_assets_generator'

module SolidusStarterFrontend
  module Generators
    # This generator is called by solidus/core/lib/spree/testing_support/common_rake.rb.
    class InstallGenerator < Rails::Generators::Base
      def vendor_assets
        SolidusStarterFrontend::VendorAssetsGenerator.start
      end
    end
  end
end
