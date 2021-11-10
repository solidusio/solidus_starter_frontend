require "solidus_starter_frontend_helper"

RSpec.describe FilterComponent, type: :component do
  describe '#call' do
    let(:filter) { Spree::Core::ProductFilters.price_filter }
    let(:search_params) { {} }

    let(:component) do
      render_inline(described_class.new(filter: filter, search_params: search_params))

      Capybara.string(rendered_component)
    end

    let(:input_ids) do
      component.all('input').map { |input| input[:id] }
    end

    it 'renders a list of checkboxes for the filter labels' do
      expect(input_ids).to_not be_empty
      expect(input_ids.first).to eq('Price_Range_Under__10.00')
    end

    context 'when a filter list item was checked' do
      let(:search_params) do
        { price_range_any: ["Under $10.00"] }
      end

      it 'renders as checked' do
        expect(component.first('input')['checked']).to be_truthy
      end
    end

    context 'when a filter list item was not checked' do
      let(:search_params) { { } }

      it 'renders as unchecked' do
        expect(component.first('input')['checked']).to be_falsey
      end
    end
  end
end
