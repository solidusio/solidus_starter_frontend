# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::BaseController, type: :controller do
  describe '#unauthorized_redirect' do
    controller(described_class) do
      def index; authorize!(:read, :something); end
    end

    before do
      stub_spree_preferences(Spree::Config, redirect_back_on_unauthorized: true)
    end

    context "when user is logged in" do
      before { sign_in(create(:user)) }

      context "when http_referrer is not present" do
        it "redirects to unauthorized path" do
          get :index
          expect(response).to redirect_to(spree.unauthorized_path)
        end
      end

      context "when http_referrer is present" do
        before { request.env['HTTP_REFERER'] = '/redirect' }

        it "redirects back" do
          get :index
          expect(response).to redirect_to('/redirect')
        end
      end
    end

    context "when user is not logged in" do
      context "when http_referrer is not present" do
        it "redirects to login path" do
          get :index
          expect(response).to redirect_to(spree.login_path)
        end
      end

      context "when http_referrer is present" do
        before { request.env['HTTP_REFERER'] = '/redirect' }

        it "redirects back" do
          get :index
          expect(response).to redirect_to('/redirect')
        end
      end
    end
  end
end
