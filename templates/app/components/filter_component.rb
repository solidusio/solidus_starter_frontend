# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  attr_reader :local_assigns

  def initialize(local_assigns = {})
    @local_assigns = local_assigns
  end

  def call
    render 'spree/components/search/filter', local_assigns
  end
end
