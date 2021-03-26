# frozen_string_literal: true

shared_context 'order state machine without delivery' do
  before do
    @old_checkout_flow = Spree::Order.checkout_flow
    Spree::Order.class_eval do
      remove_checkout_step :delivery
    end
  end

  after do
    Spree::Order.checkout_flow(&@old_checkout_flow)
  end
end
