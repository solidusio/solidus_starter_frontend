# frozen_string_literal: true

RSpec.describe Spree::CheckoutController, type: :controller do
  let(:order) { create(:order_with_line_items, email: nil, user: nil, guest_token: token) }
  let(:user)  { build(:user, spree_api_key: 'fake') }
  let(:token) { 'some_token' }
  let(:cookie_token) { token }

  before do
    request.cookie_jar.signed[:guest_token] = cookie_token
    allow(controller).to receive(:current_order) { order }
    allow(order).to receive(:confirmation_required?) { true }
  end

  context '#edit' do
    context 'when registration step enabled' do
      context 'when authenticated as registered user' do
        before { allow(controller).to receive(:spree_current_user) { user } }

        it 'proceeds to the first checkout step' do
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when not authenticated as guest' do
        it 'redirects to registration step' do
          get :edit, params: { state: 'address' }
          expect(response).to redirect_to spree.checkout_registration_path
        end
      end

      context 'when authenticated as guest' do
        before { order.email = 'guest@solidus.io' }

        it 'proceeds to the first checkout step' do
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end

        context 'when guest checkout not allowed' do
          before do
            stub_spree_preferences(allow_guest_checkout: false)
          end

          it 'redirects to registration step' do
            get :edit, params: { state: 'address' }
            expect(response).to redirect_to spree.checkout_registration_path
          end
        end
      end
    end

    context 'when registration step disabled' do
      before do
        stub_spree_preferences(Spree::Auth::Config, registration_step: false)
      end

      context 'when authenticated as registered' do
        before { allow(controller).to receive(:spree_current_user) { user } }

        it 'proceeds to the first checkout step' do
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'proceeds to the first checkout step' do
          get :edit, params: { state: 'address' }
          expect(response).to render_template :edit
        end
      end
    end
  end

  context '#update' do
    context 'when in the confirm state' do
      before do
        order.update(email: 'spree@example.com', state: 'confirm')

        # So that the order can transition to complete successfully
        allow(order).to receive(:payment_required?) { false }
      end

      context 'with a token' do
        before { allow(order).to receive(:guest_token) { 'ABC' } }

        it 'redirects to the tokenized order view' do
          request.cookie_jar.signed[:guest_token] = 'ABC'
          post :update, params: { state: 'confirm' }
          expect(response).to redirect_to spree.token_order_path(order, 'ABC')
          expect(flash.notice).to eq I18n.t('spree.order_processed_successfully')
        end
      end

      context 'with a registered user' do
        before do
          allow(controller).to receive(:spree_current_user) { user }
          allow(order).to receive(:user) { user }
          allow(order).to receive(:guest_token) { nil }
        end

        it 'redirects to the standard order view' do
          post :update, params: { state: 'confirm' }
          expect(response).to redirect_to spree.order_path(order)
        end
      end
    end
  end

  context '#registration' do
    it 'does not check registration' do
      expect(controller).not_to receive(:check_registration)
      get :registration
    end

    it 'checks if the user is authorized for :edit' do
      expect(controller).to receive(:authorize!).with(:edit, order, token)
      request.cookie_jar.signed[:guest_token] = token
      get :registration, params: {}
    end
  end

  context '#update_registration' do
    subject { put :update_registration, params: { order: { email: email } } }
    let(:email) { 'foo@example.com' }

    it 'does not check registration' do
      expect(controller).not_to receive(:check_registration)
      subject
    end

    it 'redirects to the checkout_path after saving' do
      subject
      expect(response).to redirect_to spree.checkout_path
    end

    # Regression test for https://github.com/solidusio/solidus/issues/1588
    context 'order in address state' do
      let(:order) do
        create(
          :order_with_line_items,
          email: nil,
          user: nil,
          guest_token: token,
          bill_address: nil,
          ship_address: nil,
          state: 'address'
        )
      end

      # This may seem out of left field, but previously there was an issue
      # where address would be built in a before filter and then would be saved
      # when trying to update the email.
      it "doesn't create addresses" do
        expect {
          subject
        }.not_to change { Spree::Address.count }
        expect(response).to redirect_to spree.checkout_path
      end
    end

    context 'invalid email' do
      let(:email) { 'invalid' }

      it 'renders the registration view' do
        subject
        expect(flash[:registration_error]).to eq I18n.t(:email_is_invalid, scope: [:errors, :messages])
        expect(response).to render_template :registration
      end
    end

    context 'with wrong order token' do
      let(:cookie_token) { 'lol_no_access' }

      it 'redirects to login' do
        put :update_registration, params: { order: { email: 'foo@example.com' } }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'without order token' do
      let(:cookie_token) { nil }

      it 'redirects to login' do
        put :update_registration, params: { order: { email: 'foo@example.com' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
