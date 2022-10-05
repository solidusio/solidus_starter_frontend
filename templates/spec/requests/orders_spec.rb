# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'Order', type: :request do
  let!(:store) { create(:store) }
  let(:variant) { create(:variant) }

  context "#update" do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    context "when authorization", with_guest_session: true do
      it "renders the edit view (on failure)" do
        # email validation is only after address state
        order.update_column(:state, "delivery")
        patch update_cart_path, params: { order: { email: "" } }
        expect(response).to render_template 'carts/edit'
      end

      it "redirects to cart path (on success)" do
        patch update_cart_path, params: { order: { email: 'test@email.com' } }
        expect(response).to redirect_to(edit_cart_path)
      end

      it "advances the order if :checkout button is pressed" do
        expect do
          patch update_cart_path, params: { checkout: true }
        end.to change { order.reload.state }.from('cart').to('address')

        expect(response).to redirect_to checkout_state_path('address')
      end
    end
  end

  context "#empty", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    it "destroys line items in the current order" do
      put empty_cart_path

      expect(response).to redirect_to(edit_cart_path)
      expect(order.reload.line_items).to be_blank
    end
  end

  context "when line items quantity is 0", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }
    let(:line_item) { order.line_items.first }

    it "removes line items on update" do
      expect(order.line_items.count).to eq 1

      patch update_cart_path, params: { order: { line_items_attributes: { "0" => { id: line_item.id, quantity: 0 } } } }

      expect(order.reload.line_items.count).to eq 0
    end
  end
end
