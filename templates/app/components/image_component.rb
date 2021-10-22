# frozen_string_literal: true

class ImageComponent < ViewComponent::Base
  attr_reader :local_assigns, :image

  def initialize(local_assigns = {})
    @local_assigns = local_assigns
    @image = local_assigns[:image]
  end
end
