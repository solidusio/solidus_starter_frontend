module SystemHelpers
  def checkout_as_guest
    click_button "Checkout"

    # RspecGenerator/with-authentication/start
    within '#guest_checkout' do
      fill_in 'Email', with: 'test@example.com'
    end
    # RspecGenerator/with-authentication/end

    click_on 'Continue'
  end
end
