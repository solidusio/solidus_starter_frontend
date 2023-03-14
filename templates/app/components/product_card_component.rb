# frozen_string_literal: true

class ProductCardComponent < ViewComponent::Base
  def initialize(product, taxon: nil, locale: I18n.locale, price: product.master.default_price)
    @product = product
    @taxon = taxon
    @locale = locale
    @price = price
  end

  attr_reader :product, :taxon, :locale, :price

  def main_image
    product.gallery.images.first
  end

  def display_price
    @display_price ||= price&.money
  end

  def url
    @url ||= product_path(product, taxon_id: taxon.try(:id))
  end
end
