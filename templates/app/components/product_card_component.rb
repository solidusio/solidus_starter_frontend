# frozen_string_literal: true

class ProductCardComponent < ViewComponent::Base
  def initialize(product, locale: I18n.locale, price: product.master.default_price)
    @product = product
    @locale = locale
    @price = price
  end

  attr_reader :product, :locale, :price

  def main_image
    product.gallery.images.first
  end

  def display_price
    @display_price ||= price&.money
  end
end
