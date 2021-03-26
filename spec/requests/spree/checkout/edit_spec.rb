# frozen_string_literal: true

require 'spec_helper'

describe 'Checkout Edit', type: :request do
  context 'when user is logged', with_signed_in_user: true do
    let!(:order) { create(:order_with_line_items, user: user) }
    let(:user) { create(:user) }

    context 'when order is not found' do
    end

    context 'when trying to access a future step' do
    end

    context 'when order is completed' do
    end

    context 'when checkout is not allowed' do
    end

    context 'when authorized' do
    end

    context 'when order state machine has not delivery step' do
    end
  end
end
