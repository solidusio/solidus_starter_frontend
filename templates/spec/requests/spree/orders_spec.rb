# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'Order', type: :request do
  let!(:store) { create(:store) }
  let(:variant) { create(:variant) }

  context "#populate" do
    it "creates a new order when none specified" do
      expect do
        post spree.populate_orders_path, params: { variant_id: variant.id }
      end.to change(Spree::Order, :count).by(1)

      expect(response).to be_redirect
      expect(response.cookies['guest_token']).not_to be_blank

      jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
      order_by_token = Spree::Order.find_by(guest_token: jar.signed[:guest_token])

      expect(order_by_token).to be_persisted
    end

    context "when variant" do
      let(:user) { create(:user) }

      it "handles population", with_signed_in_user: true do
        expect do
          post spree.populate_orders_path, params: { variant_id: variant.id, quantity: 5 }
        end.to change { user.orders.count }.by(1)
        expect(response).to redirect_to spree.cart_path
        order = user.orders.first
        expect(order.line_items.size).to eq(1)
        line_item = order.line_items.first
        expect(line_item.variant_id).to eq(variant.id)
        expect(line_item.quantity).to eq(5)
      end

      context 'when fails to populate' do
        it "shows an error when quantity is invalid" do
          post(
            spree.populate_orders_path,
            headers: { 'HTTP_REFERER' => spree.root_path },
            params: { variant_id: variant.id, quantity: -1 }
          )

          expect(response).to redirect_to(spree.root_path)
          expect(flash[:error]).to eq(
            I18n.t('spree.please_enter_reasonable_quantity')
          )
        end
      end

      context "when quantity is empty string" do
        it "populates order with 1 of given variant" do
          expect do
            post spree.populate_orders_path, params: { variant_id: variant.id, quantity: '' }
          end.to change { Spree::Order.count }.by(1)
          order = Spree::Order.last
          expect(response).to redirect_to spree.cart_path
          expect(order.line_items.size).to eq(1)
          line_item = order.line_items.first
          expect(line_item.variant_id).to eq(variant.id)
          expect(line_item.quantity).to eq(1)
        end
      end

      context "when quantity is nil" do
        it "populates order with 1 of given variant" do
          expect do
            post spree.populate_orders_path, params: { variant_id: variant.id, quantity: nil }
          end.to change { Spree::Order.count }.by(1)
          order = Spree::Order.last
          expect(response).to redirect_to spree.cart_path
          expect(order.line_items.size).to eq(1)
          line_item = order.line_items.first
          expect(line_item.variant_id).to eq(variant.id)
          expect(line_item.quantity).to eq(1)
        end
      end
    end
  end

  context '#edit' do
    context 'when guest user', with_guest_session: true do
      let(:order) { create(:order, user: nil, store: store) }

      it 'renders the cart' do
        get spree.edit_order_path(order.number)

        expect(flash[:error]).to be_nil
        expect(response).to be_ok
      end

      context 'when another order number than the current_order' do
        let(:other_order) { create(:completed_order_with_totals, email: 'test@email.com', user: nil, store: store) }

        it 'displays error message' do
          get spree.edit_order_path(other_order.number)

          expect(flash[:error]).to eq "You may only edit your current shopping cart."
          expect(response).to redirect_to spree.cart_path
        end
      end
    end

    context 'when logged in user', with_signed_in_user: true do
      let(:user) { create(:user) }

      it "builds a new valid order with complete meta-data" do
        get spree.cart_path

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
        put spree.order_path(order.number), params: { order: { email: "" } }
        expect(response).to render_template :edit
      end

      it "redirects to cart path (on success)" do
        put spree.order_path(order.number), params: { order: { email: 'test@email.com' } }
        expect(response).to redirect_to(spree.cart_path)
      end

      it "advances the order if :checkout button is pressed" do
        expect do
          put spree.order_path(order.number), params: { checkout: true }
        end.to change { order.reload.state }.from('cart').to('address')

        expect(response).to redirect_to spree.checkout_state_path('address')
      end
    end

    context 'when order is not present' do
      it "cannot update a blank order" do
        put spree.order_path('not_existing_order'), params: { order: { email: 'test@email.com' } }

        expect(flash[:error]).to eq(I18n.t('spree.order_not_found'))
        expect(response).to redirect_to(spree.root_path)
      end
    end
  end

  context "#empty", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    it "destroys line items in the current order" do
      put spree.empty_cart_path

      expect(response).to redirect_to(spree.cart_path)
      expect(order.reload.line_items).to be_blank
    end
  end

  context "when line items quantity is 0", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }
    let(:line_item) { order.line_items.first }

    it "removes line items on update" do
      expect(order.line_items.count).to eq 1

      put spree.order_path(order.number), params: { order: { line_items_attributes: { "0" => { id: line_item.id, quantity: 0 } } } }

      expect(order.reload.line_items.count).to eq 0
    end
  end
end
