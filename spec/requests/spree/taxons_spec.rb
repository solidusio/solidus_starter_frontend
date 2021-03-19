# frozen_string_literal: true

require 'spec_helper'

describe Spree::TaxonsController, type: :request, with_signed_in_user: true do
  let(:user) { mock_model(Spree.user_class, has_spree_role?: 'admin', spree_api_key: 'fake') }

  it "provides the current user to the searcher class" do
    taxon = create(:taxon, permalink: "test")
    get spree.nested_taxons_path(taxon.permalink)

    expect(assigns[:searcher].current_user).to eq user
    expect(response.status).to eq(200)
  end
end
