require "solidus_starter_frontend_spec_helper"

# I'm getting the "NameError Exception: uninitialized constant
# `#<Class:0x000056478b9a4100>::ActiveStorageAttachment`" in byebug unless I
# require spree/taxon.
require 'spree/taxon'

RSpec.describe BreadcrumbsComponent, type: :component do
  let(:request_url) { '/' }

  let(:breadcrumb_items) do
    page.all('a[itemprop=item]').map(&:text)
  end

  context 'when rendered' do
    before do
      with_request_url(request_url) do
        render_inline(described_class.new(taxon))
      end
    end

    context 'when the taxon is nil' do
      let(:taxon) { nil }

      it 'does not render any breadcrumb items' do
        expect(breadcrumb_items.size).to eq(0)
      end
    end

    context 'when the taxon is present' do
      let(:taxon) { create(:taxon, name: 'some taxon') }

      context 'when the current page is the root page' do
        let(:request_url) { '/' }

        it 'does not render any breadcrumb items' do
          expect(breadcrumb_items.size).to eq(0)
        end
      end

      context 'when the current page is not the root page' do
        let(:request_url) { '/products' }

        it 'renders a breadcrumb for the taxon and its ancestors' do
          expect(breadcrumb_items.size).to eq(4)
          expect(breadcrumb_items[-4]).to eq('Home')
          expect(breadcrumb_items[-3]).to eq('Products')
          expect(breadcrumb_items[-2]).to eq(taxon.parent.name) # default taxonomy taxon root
          expect(breadcrumb_items[-1]).to eq(taxon.name)
        end
      end
    end
  end
end
