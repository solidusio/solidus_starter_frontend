require "solidus_starter_frontend_helper"

RSpec.describe FilterComponent, type: :component do
  describe '#call' do
    let(:filter) { Spree::Core::ProductFilters.price_filter }

    let(:local_assigns) { { filter: filter } }

    let(:component) do
      render_inline(described_class.new(local_assigns))

      Capybara.string(rendered_component)
    end

    let(:input_ids) do
      component.all('input').map { |input| input[:id] }
    end

    it 'renders a list of checkboxes for the filter labels' do
      expect(input_ids).to_not be_empty
      expect(input_ids.first).to eq('Price_Range_Under_$10.00')
    end
  end
end
