# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

# In this file, we want to test that the controller helpers function correctly
# So we need to use one of the controllers inside Spree.
# ProductsController is good.
RSpec.describe Spree::ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    I18n.enforce_available_locales = false
    stub_spree_preferences(SolidusStarterFrontend::Config, locale: :de)
    I18n.backend.store_translations(:de, spree: {
      i18n: { this_file_language: "Deutsch (DE)" }
    })
  end

  after do
    I18n.reload!
    I18n.locale = :en
    I18n.enforce_available_locales = true
  end

  # Regression test for https://github.com/spree/spree/issues/1184
  it "sets the default locale based off SolidusStarterFrontend::Config[:locale]" do
    expect(I18n.locale).to eq(:en)
    get :index
    expect(I18n.locale).to eq(:de)
  end
end
