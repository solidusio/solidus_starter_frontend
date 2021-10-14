# frozen_string_literal: true

require 'solidus_starter_frontend_helper'

module Spree
  RSpec.describe SolidusStarterFrontendHelper, type: :helper do
    describe 'solidus_button_inline' do
      let(:input) { solidus_button_inline(arguments) }
      subject(:normalized_input) { input.gsub(/\n\s*/, '') }

      context 'when only required arguments are provided' do
        let(:arguments) { {} }

        let(:expected_result) do
          %Q{<button type="button" class="button-inline" id="false"></button>}
        end

        it 'returns an inline button tag' do
          expect(normalized_input).to eq(expected_result)
        end
      end

      context 'when all arguments are provided' do
        let(:arguments) do
          {
            content: 'some-content',
            type: 'another-button-type',
            classes: ['some-class'],
            disabled: true,
            id: 'some-id',
            name: 'some-name'
          }
        end

        let(:expected_properties) do
          %Q{
            name="some-name"
            type="another-button-type"
            class="some-class button-inline"
            disabled="disabled"
            id="some-id"
          }.squish
        end

        let(:expected_result) do
          "<button #{expected_properties}>some-content</button>"
        end

        it 'returns an inline button tag matching those arguments' do
          expect(normalized_input).to eq(expected_result)
        end
      end
    end
  end
end
