module SolidusStarterFrontend::SystemHelpers
  def checkout_as_guest
    click_button "Checkout"

    within '#guest_checkout' do
      fill_in 'Email', with: 'test@example.com'
    end

    click_on 'Continue'
  end

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
