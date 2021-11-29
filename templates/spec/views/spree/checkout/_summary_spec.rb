# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'spree/checkout/_checkout_summary.html.erb', type: :view do
  # Regression spec for https://github.com/spree/spree/issues/4223
  it 'does not use the @order instance variable' do
    order = stub_model(Spree::Order)
    render 'spree/checkout/checkout_summary', order: order
  end
end
