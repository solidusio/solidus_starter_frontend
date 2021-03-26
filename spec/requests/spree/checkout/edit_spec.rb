# frozen_string_literal: true

require 'spec_helper'

describe 'Checkout Edit', type: :request do
  context 'when user is logged', with_signed_in_user: true do
    let!(:order) { create(:order_with_line_items, user: user) }
    let(:user) { create(:user) }

    context 'when order is not found' do
      let(:order) { nil }

      it 'redirects to cart path' do
        get spree.checkout_path, params: { state: 'delivery' }

        expect(response).to redirect_to(spree.cart_path)
      end
    end

    context 'when trying to access a future step' do
      before { order.update_column(:state, 'address') }

      # Regression test for https://github.com/spree/spree/issues/2280
      it 'redirects to current step' do
        get spree.checkout_path, params: { state: 'delivery' }

        expect(response).to redirect_to spree.checkout_state_path('address')
      end
    end

    context 'when order is completed' do
      before { order.touch(:completed_at) }

      it 'redirects to cart path' do
        get spree.checkout_path, params: { state: 'address' }

        expect(response).to redirect_to(spree.cart_path)
      end
    end

    context 'when checkout is not allowed' do
      before { order.line_items.destroy_all }

      it 'redirects to the cart path' do
        get spree.checkout_path, params: { state: 'delivery' }

        expect(response).to redirect_to(spree.cart_path)
      end
    end

    context 'when authorized' do
      it 'returns 200' do
        get spree.checkout_path, params: { state: 'address' }

        expect(assigns[:order]).to eq order
        expect(status).to eq(200)
      end
    end

    context 'when order state machine has not delivery step' do
      include_context 'order state machine without delivery'

      let(:order) { create(:order_with_line_items, user: user, ship_address: nil, state: 'address') }
      let(:address) { build(:address) }
      let(:address_params) { address.attributes.except('created_at', 'updated_at') }

      it "doesn't set a default shipping address on the order" do
        get spree.checkout_path, params: { state: order.state, order: { bill_address_attributes: address_params } }
        expect(assigns[:order].ship_address).to be_nil
      end
    end
  end
end
