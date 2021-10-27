require "solidus_starter_frontend_helper"

RSpec.describe ImageComponent, type: :component do
  def normalize_html(html)
    html.gsub(/\n */, '')
  end

  let(:normalized_expected_match) do
    Regexp.new(normalize_html(expected_match))
  end

  let(:component) do
    render_inline(described_class.new(arguments))

    rendered_component
  end

  subject(:normalized_component) { normalize_html(component) }

  context 'when no arguments are provided' do
    let(:arguments) { { } }

    it 'renders a placeholder' do
      expect(normalized_component).to eq(%Q{<div class="image-placeholder mini"></div>})
    end
  end

  context 'when an image is provided' do
    let(:alt) { 'some-alt' }
    let(:image) { build(:image, alt: alt) }
    let(:arguments) { { image: image } }

    context 'when the image has an alt' do
      let(:alt) { 'some-alt' }

      let(:expected_match) do
        %Q{
          <img alt="some-alt" src="/assets/noimage/mini-.*.png" />
        }
      end

      let(:normalized_expected_match) do
        Regexp.new(normalize_html(expected_match))
      end

      it 'renders the image' do
        expect(normalized_component).to match(normalized_expected_match)
      end
    end

    context 'when the image does not have an alt' do
      let(:alt) { nil }

      let(:expected_match) do
        %Q{
          <img src="/assets/noimage/mini-.*.png" />
        }
      end

      it 'renders the image' do
        expect(normalized_component).to match(normalized_expected_match)
      end
    end
  end

  context 'when all the required arguments are provided' do
    let(:arguments) do
      {
        image: build(:image),
        size: :small,
        itemprop: 'some-itemprop',
        classes: ['some-class'],
        data: { key: 'value' },
      }
    end

    let(:expected_match) do
      %Q{
        <img class="some-class" itemprop="some-itemprop" data-key="value" src="/assets/noimage/small-.*.png" />
      }
    end

    it 'renders the image' do
      expect(normalized_component).to match(normalized_expected_match)
    end
  end
end
