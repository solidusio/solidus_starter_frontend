# frozen_string_literal: true

class LinkToCartComponent < ViewComponent::Base
  attr_reader :text

  delegate :current_order, :spree, to: :helpers

  def initialize(text = nil)
    @text = text
  end

  def call
    link_to_cart(text)
  end

  private

  # Copied from https://github.com/solidusio/solidus-demo/blob/3c11395ef6bfda0b906f68dbd11ab5ff567da747/app/monkey_patches/spree/base_helper_monkey_patch.rb
  # Added "Cart" title to link primarily to get the tests to pass.
  def link_to_cart(text = nil)
    text = text ? h(text) : t('spree.cart')
    css_class = nil

    if current_order.nil? || current_order.item_count.zero?
      text = ""
      css_class = 'empty'
    else
      text = "<div class='link-text'>#{current_order.item_count}</div>"\
            #"<span class='amount'>#{current_order.display_total.to_html}</span>"
      css_class = 'full'
    end
    link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}", title: 'Cart'
  end
end
