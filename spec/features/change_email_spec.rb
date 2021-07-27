# frozen_string_literal: true

RSpec.feature 'Change email', type: :feature do
  background do
    stub_spree_preferences(Spree::Auth::Config, signout_after_password_change: false)

    user = create(:user)
    visit spree.root_path
    click_link 'Login'

    fill_in 'spree_user[email]', with: user.email
    fill_in 'spree_user[password]', with: 'secret'
    click_button 'Login'

    visit spree.edit_account_path
  end

  scenario 'work with correct password' do
    fill_in 'user_email', with: 'tests@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Update'

    expect(page).to have_text 'Account updated'
    expect(page).to have_text 'tests@example.com'
  end
end
