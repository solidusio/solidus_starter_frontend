# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

RSpec.describe 'Order', type: :request do
  let!(:store) { create(:store) }
  let(:variant) { create(:variant) }

  context "#empty", with_guest_session: true do
    let(:order) { create(:order_with_line_items, user: nil, store: store) }

    it "destroys line items in the current order" do
      put empty_cart_path

      expect(response).to redirect_to(edit_cart_path)
      expect(order.reload.line_items).to be_blank
    end
  end
end
