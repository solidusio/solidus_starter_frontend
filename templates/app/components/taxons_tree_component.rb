# frozen_string_literal: true

class TaxonsTreeComponent < ViewComponent::Base
  attr_reader :local_assigns

  def initialize(local_assigns = {})
    @local_assigns = local_assigns
  end

  def call
    render 'spree/shared/navigation/taxons_tree', local_assigns: local_assigns
  end
end
