# frozen_string_literal: true

require 'solidus_starter_frontend_spec_helper'

RSpec.describe 'searching products', type: :system do
  include_context "custom products"

  before(:each) do
    visit root_path
  end

  it 'falls back to normal search for plain HTML requests' do
    fill_in 'keywords', with: 'shirt'
    click_button 'Search'

    expect(page.all('ul.products-grid li').size).to eq(1)
  end

  it 'shows a blank slate for empty searches' do
    fill_in 'keywords', with: 'this-product-does-not-exist'
    click_button 'Search'
    expect(page).to have_content('No products found')
  end

  context 'with JS enabled', :js do
    it 'shows autocomplete suggestions' do
      fill_in 'keywords', with: 'ruby'
      expect(page.all('[data-search-target="result"]').size).to eq(8)
    end

    it 'automatically selects the first suggestion' do
      fill_in 'keywords', with: 'ruby'
      expect(page.all('[data-search-target="result"]')[0][:class]).to include('autocomplete-results__item--current')
    end

    it 'scrolls up and down through suggestions using up/down arrow keys' do
      fill_in 'keywords', with: 'ruby'
      wait_for_autocomplete

      find('input[name=keywords]').native.send_keys(:down)
      expect(page.all('[data-search-target="result"]')[1][:class]).to include('autocomplete-results__item--current')

      find('input[name=keywords]').native.send_keys(:up)
      expect(page.all('[data-search-target="result"]')[0][:class]).to include('autocomplete-results__item--current')
    end

    it 'allows mouse click on results' do
      fill_in 'keywords', with: 'ruby'
      wait_for_autocomplete
      find_all('[data-search-target="result"]')[0].click

      expect(page).to have_current_path('/products/ruby-on-rails-ringer-t-shirt')
    end

    it 'clicks on a suggestion pressing enter' do
      fill_in 'keywords', with: 'ruby'
      wait_for_autocomplete
      find('input[name=keywords]').native.send_keys(:enter)

      expect(page).to have_current_path('/products/ruby-on-rails-ringer-t-shirt')
    end

    it 'closes autocomplete suggestions pressing esc key' do
      fill_in 'keywords', with: 'ruby'
      wait_for_autocomplete
      find('input[name=keywords]').native.send_keys(:escape)

      expect(page).not_to have_selector('[data-search-target="result"]', visible: true)
    end

    it 'closes autocomplete suggestions clicking outside the search input' do
      fill_in 'keywords', with: 'ruby'
      wait_for_autocomplete
      find('input[name=keywords]').native.send_keys(:escape)

      find('.top-bar').click
      expect(page).not_to have_selector('[data-search-target="result"]', visible: true)
    end

    def wait_for_autocomplete
      expect(page).to have_selector('[data-search-target="result"]', visible: true)
    end
  end
end
