# frozen_string_literal: true

module Spree
  # This is somewhat contrary to standard REST convention since there is not
  # actually a Checkout object. There's enough distinct logic specific to
  # checkout which has nothing to do with updating an order that this approach
  # is warranted.
  class CheckoutController < Spree::StoreController
    before_action :load_order
    around_action :lock_order

    before_action :ensure_order_is_not_skipping_states
    before_action :ensure_order_not_completed
    before_action :ensure_checkout_allowed
    before_action :ensure_sufficient_stock_lines
    before_action :ensure_valid_state

    before_action :associate_user
    before_action :check_registration, except: [:registration, :update_registration]
    before_action :check_authorization

    before_action :setup_for_current_state, only: [:edit, :update]

    helper 'spree/orders'

    rescue_from Spree::Core::GatewayError, with: :rescue_from_spree_gateway_error
    rescue_from Spree::Order::InsufficientStock, with: :insufficient_stock_error

    # Updates the order and advances to the next state (when possible.)
    def update
      if update_order

        assign_temp_address

        unless transition_forward
          redirect_on_failure
          return
        end

        if @order.completed?
          finalize_order
        else
          send_to_next_state
        end

      else
        render :edit
      end
    end

    def registration
      @user = Spree::User.new
    end

    def update_registration
      if params[:order][:email] =~ Devise.email_regexp && current_order.update(email: params[:order][:email])
        redirect_to spree.checkout_path
      else
        flash[:registration_error] = t(:email_is_invalid, scope: [:errors, :messages])
        @user = Spree::User.new
        render 'registration'
      end
    end

    private

    def update_order
      Spree::OrderUpdateAttributes.new(@order, update_params, request_env: request.headers.env).apply
    end

    def assign_temp_address
      @order.temporary_address = !params[:save_user_address]
    end

    def redirect_on_failure
      flash[:error] = @order.errors.full_messages.join("\n")
      redirect_to(checkout_state_path(@order.state))
    end

    def transition_forward
      if @order.can_complete?
        @order.complete
      else
        @order.next
      end
    end

    def finalize_order
      @current_order = nil
      set_successful_flash_notice
      redirect_to completion_route
    end

    def set_successful_flash_notice
      flash.notice = t('spree.order_processed_successfully')
      flash['order_completed'] = true
    end

    def send_to_next_state
      redirect_to checkout_state_path(@order.state)
    end

    def update_params
      case params[:state].to_sym
      when :address
        massaged_params.require(:order).permit(
          permitted_checkout_address_attributes
        )
      when :delivery
        massaged_params.require(:order).permit(
          permitted_checkout_delivery_attributes
        )
      when :payment
        massaged_params.require(:order).permit(
          permitted_checkout_payment_attributes
        )
      else
        massaged_params.fetch(:order, {}).permit(
          permitted_checkout_confirm_attributes
        )
      end
    end

    def massaged_params
      massaged_params = params.deep_dup

      move_payment_source_into_payments_attributes(massaged_params)
      move_wallet_payment_source_id_into_payments_attributes(massaged_params)
      set_payment_parameters_amount(massaged_params, @order)

      massaged_params
    end

    def ensure_valid_state
      unless skip_state_validation?
        if (params[:state] && !@order.has_checkout_step?(params[:state])) ||
           (!params[:state] && !@order.has_checkout_step?(@order.state))
          @order.state = 'cart'
          redirect_to checkout_state_path(@order.checkout_steps.first)
        end
      end

      # Fix for https://github.com/spree/spree/issues/4117
      # If confirmation of payment fails, redirect back to payment screen
      if params[:state] == "confirm" && @order.payment_required? && @order.payments.valid.empty?
        flash.keep
        redirect_to checkout_state_path("payment")
      end
    end

    # Should be overriden if you have areas of your checkout that don't match
    # up to a step within checkout_steps, such as a registration step
    def skip_state_validation?
      false
    end

    def load_order
      @order = current_order
      redirect_to(spree.cart_path) && return unless @order
    end

    # Allow the customer to only go back or stay on the current state
    # when trying to change it via params[:state]. It's not allowed to
    # jump forward and skip states (unless #skip_state_validation? is
    # truthy).
    def ensure_order_is_not_skipping_states
      if params[:state]
        redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
        @order.state = params[:state]
      end
    end

    def ensure_checkout_allowed
      unless @order.checkout_allowed?
        redirect_to spree.cart_path
      end
    end

    def ensure_order_not_completed
      redirect_to spree.cart_path if @order.completed?
    end

    def ensure_sufficient_stock_lines
      if @order.insufficient_stock_lines.present?
        out_of_stock_items = @order.insufficient_stock_lines.collect(&:name).to_sentence
        flash[:error] = t('spree.inventory_error_flash_for_insufficient_quantity', names: out_of_stock_items)
        redirect_to spree.cart_path
      end
    end

    def setup_for_current_state
      method_name = :"before_#{@order.state}"
      send(method_name) if respond_to?(method_name, true)
    end

    def before_address
      @order.assign_default_user_addresses
      # If the user has a default address, the previous method call takes care
      # of setting that; but if he doesn't, we need to build an empty one here
      @order.bill_address ||= Spree::Address.build_default
      @order.ship_address ||= Spree::Address.build_default if @order.checkout_steps.include?('delivery')
    end

    def before_delivery
      return if params[:order].present?

      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
    end

    def before_payment
      if @order.checkout_steps.include? "delivery"
        packages = @order.shipments.map(&:to_package)
        @differentiator = Spree::Stock::Differentiator.new(@order, packages)
        @differentiator.missing.each do |variant, quantity|
          @order.contents.remove(variant, quantity)
        end
      end

      if try_spree_current_user && try_spree_current_user.respond_to?(:wallet)
        @wallet_payment_sources = try_spree_current_user.wallet.wallet_payment_sources
        @default_wallet_payment_source = @wallet_payment_sources.detect(&:default) ||
                                         @wallet_payment_sources.first
      end
    end

    def rescue_from_spree_gateway_error(exception)
      flash.now[:error] = t('spree.spree_gateway_error_flash_for_checkout')
      @order.errors.add(:base, exception.message)
      render :edit
    end

    def insufficient_stock_error
      packages = @order.shipments.map(&:to_package)
      if packages.empty?
        flash[:error] = I18n.t('spree.insufficient_stock_for_order')
        redirect_to cart_path
      else
        availability_validator = Spree::Stock::AvailabilityValidator.new
        unavailable_items = @order.line_items.reject { |line_item| availability_validator.validate(line_item) }
        if unavailable_items.any?
          item_names = unavailable_items.map(&:name).to_sentence
          flash[:error] = t('spree.inventory_error_flash_for_insufficient_shipment_quantity', unavailable_items: item_names)
          @order.restart_checkout_flow
          redirect_to spree.checkout_state_path(@order.state)
        end
      end
    end

    def order_params
      params.
        fetch(:order, {}).
        permit(:email)
    end

    def skip_state_validation?
      %w(registration update_registration).include?(params[:action])
    end

    def check_authorization
      authorize!(:edit, current_order, cookies.signed[:guest_token])
    end

    # Introduces a registration step whenever the +registration_step+ preference is true.
    def check_registration
      return unless registration_required?

      store_location
      redirect_to spree.checkout_registration_path
    end

    def registration_required?
      Spree::Auth::Config[:registration_step] &&
        !already_registered?
    end

    def already_registered?
      spree_current_user || guest_authenticated?
    end

    def guest_authenticated?
      current_order&.email.present? &&
        Spree::Config[:allow_guest_checkout]
    end

    # Overrides the equivalent method defined in Spree::Core.  This variation of the method will ensure that users
    # are redirected to the tokenized order url unless authenticated as a registered user.
    def completion_route
      return spree.order_path(@order) if spree_current_user

      spree.token_order_path(@order, @order.guest_token)
    end
  end
end
