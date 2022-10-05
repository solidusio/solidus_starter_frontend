# frozen_string_literal: true

class CartsController < StoreController
  helper 'spree/products', 'orders'

  respond_to :html

  before_action :store_guest_token

  # Shows the current incomplete order from the session
  def edit
    @order = current_order(build_order_if_necessary: true)
    authorize! :edit, @order, cookies.signed[:guest_token]
    if params[:id] && @order.number != params[:id]
      flash[:error] = t('spree.cannot_edit_orders')
      redirect_to edit_cart_path
    end
  end

  private

  def accurate_title
    t('spree.shopping_cart')
  end

  def store_guest_token
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
  end
end
