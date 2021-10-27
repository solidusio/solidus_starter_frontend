# frozen_string_literal: true

module Spree
  module SolidusStarterFrontendHelper
    def generate_address_id(form, input_name)
      "#{form.object_name.gsub(/[\[\]]/, '[' => '_', ']' => '_')}#{input_name}"
    end
  end
end
