# frozen_string_literal: true

class TaxonsTreeComponent < ViewComponent::Base
  attr_reader :local_assigns

  def initialize(local_assigns = {})
    @local_assigns = local_assigns
  end

  private

  def seo_url(taxon)
    helpers.spree.nested_taxons_path(taxon.permalink)
  end
end
