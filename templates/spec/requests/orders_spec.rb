# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'Order', type: :request do
  let!(:store) { create(:store) }
  let(:variant) { create(:variant) }

  context '#edit' do
    context 'when guest user', with_guest_session: true do
      let(:order) { create(:order, user: nil, store: store) }

      it 'renders the cart' do
        get edit_order_path(order.number)

        expect(flash[:error]).to be_nil
        expect(response).to be_ok
      end

      context 'when another order number than the current_order' do
        let(:other_order) { create(:completed_order_with_totals, email: 'test@email.com', user: nil, store: store) }

        it 'displays error message' do
          get edit_order_path(other_order.number)

          expect(flash[:error]).to eq "You may only edit your current shopping cart."
          expect(response).to redirect_to cart_path
        end
      end
    end

    context 'when logged in user', with_signed_in_user: true do
      let(:user) { create(:user) }

      it "builds a new valid order with complete meta-data" do
        get cart_path

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

  context "#update" do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    context "when authorization", with_guest_session: true do
      it "renders the edit view (on failure)" do
        # email validation is only after address state
        order.update_column(:state, "delivery")
        put order_path(order.number), params: { order: { email: "" } }
        expect(response).to render_template :edit
      end

      it "redirects to cart path (on success)" do
        put order_path(order.number), params: { order: { email: 'test@email.com' } }
        expect(response).to redirect_to(cart_path)
      end

      it "advances the order if :checkout button is pressed" do
        expect do
          put order_path(order.number), params: { checkout: true }
        end.to change { order.reload.state }.from('cart').to('address')

        expect(response).to redirect_to checkout_state_path('address')
      end
    end

    context 'when order is not present' do
      it "cannot update a blank order" do
        put order_path('not_existing_order'), params: { order: { email: 'test@email.com' } }

        expect(flash[:error]).to eq(I18n.t('spree.order_not_found'))
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context "#empty", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    it "destroys line items in the current order" do
      put empty_cart_path

      expect(response).to redirect_to(cart_path)
      expect(order.reload.line_items).to be_blank
    end
  end

  context "when line items quantity is 0", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }
    let(:line_item) { order.line_items.first }

    it "removes line items on update" do
      expect(order.line_items.count).to eq 1

      put order_path(order.number), params: { order: { line_items_attributes: { "0" => { id: line_item.id, quantity: 0 } } } }

      expect(order.reload.line_items.count).to eq 0
    end
  end
end
