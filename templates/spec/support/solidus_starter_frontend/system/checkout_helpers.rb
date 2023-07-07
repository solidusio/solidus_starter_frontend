module SolidusStarterFrontend
  module System
    module CheckoutHelpers
      #
      # Authentication
      #
      def checkout_as_guest
        click_button "Checkout"

        within '#guest_checkout' do
          fill_in 'Email', with: 'test@example.com'
        end

        click_on 'Continue'
      end

      #
      # Address
      #
      def fill_addresses_fields_with(address)
        fields = %w[
          address1
          city
          zipcode
          phone
        ]
        fields += if SolidusSupport.combined_first_and_last_name_in_address?
          %w[name]
        else
          %w[firstname lastname]
        end

        fields.each do |field|
          fill_in "order_bill_address_attributes_#{field}", with: address.send(field).to_s
        end
        select 'United States', from: "order_bill_address_attributes_country_id"
        select address.state.name.to_s, from: "order_bill_address_attributes_state_id"

        check 'order_use_billing'
      end

      #
      # Payment
      #
      def find_existing_payment_radio(wallet_source_id)
        find("[name='order[wallet_payment_source_id]'][value='#{wallet_source_id}']")
      end

      def find_payment_radio(payment_method_id)
        find("[name='order[payments_attributes][][payment_method_id]'][value='#{payment_method_id}']")
      end

      def find_payment_fieldset(payment_method_id)
        find("fieldset[name='payment-method-#{payment_method_id}']")
      end
    end
  end
end
