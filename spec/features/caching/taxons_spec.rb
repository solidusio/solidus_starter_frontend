# frozen_string_literal: true

require 'spec_helper'
require 'byebug'

describe 'taxons', type: :feature, caching: true do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy: taxonomy, parent: taxonomy.root) }

  before do
    # warm up the cache
    visit spree.root_path

    clear_cache_events
  end

  it "busts the cache when a taxon changes" do
    taxon.touch(:updated_at)

    visit spree.root_path
    expect(cache_writes.count).to eq(2)
  end

  it "busts the cache when max_level_in_taxons_menu conf changes" do
    stub_spree_preferences(max_level_in_taxons_menu: 5)
    visit spree.root_path
    expect(cache_writes.count).to eq(2)
  end
end
