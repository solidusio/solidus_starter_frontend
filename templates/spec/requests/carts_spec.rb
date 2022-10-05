# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'Cart', type: :request do
  let!(:store) { create(:store) }
  let(:variant) { create(:variant) }

  context '#edit' do
    context 'when guest user', with_guest_session: true do
      let(:order) { create(:order, user: nil, store: store) }

      it 'renders the cart' do
        get edit_cart_path

        expect(flash[:error]).to be_nil
        expect(response).to be_ok
      end
    end

    context 'when logged in user', with_signed_in_user: true do
      let(:user) { create(:user) }

      it "builds a new valid order with complete meta-data" do
        get edit_cart_path

        order = assigns[:order]

        aggregate_failures do
          expect(order).to be_valid
          expect(order).not_to be_persisted
          expect(order.store).to be_present
          expect(order.user).to eq(user)
          expect(order.created_by).to eq(user)
        end
      end
    end
  end
end
