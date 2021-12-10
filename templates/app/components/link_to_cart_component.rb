# frozen_string_literal: true

class LinkToCartComponent < ViewComponent::Base
  attr_reader :text

  def initialize(text = nil)
    @text = text
  end

  def call
    helpers.link_to_cart(text)
  end
end
