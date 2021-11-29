# frozen_string_literal: true

module Spree
  class StoreController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Pricing
    include Spree::Core::ControllerHelpers::Order
    include SolidusStarterFrontend::Taxonomies

    def unauthorized
      render 'spree/shared/auth/unauthorized', layout: Spree::Config[:layout], status: 401
    end

    def cart_link
      render partial: 'spree/shared/cart/link_to_cart'
      fresh_when(current_order, template: 'spree/shared/cart/_link_to_cart')
    end

    private

    def config_locale
      SolidusStarterFrontend::Config[:locale]
    end

    def lock_order
      Spree::OrderMutex.with_lock!(@order) { yield }
    rescue Spree::OrderMutex::LockFailed
      flash[:error] = t('spree.order_mutex_error')
      redirect_to spree.cart_path
    end
  end
end
