# frozen_string_literal: true

class LogoComponent < ViewComponent::Base
  attr_reader :image_path

  def initialize(image_path = Spree::Config[:logo])
    @image_path = image_path
  end

  def call
    link_to image_tag(image_path), root_path
  end
end
