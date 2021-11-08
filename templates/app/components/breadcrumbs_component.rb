# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  def initialize(taxon)
    @taxon = taxon
  end

  def call
    render 'spree/components/navigation/breadcrumbs', taxon: @taxon
  end
end
