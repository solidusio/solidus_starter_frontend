# frozen_string_literal: true

module Spree
  module SolidusStarterFrontendHelper
    def generate_address_id(form, input_name)
      "#{form.object_name.gsub(/[\[\]]/, '[' => '_', ']' => '_')}#{input_name}"
    end

    def generate_selected_shipping_rate_id(form, input_name, rate)
      "#{form.object_name.gsub(/[\[\]]/, '[' => '_', ']' => '_')}#{input_name}_#{rate.id}"
    end
  end
end
