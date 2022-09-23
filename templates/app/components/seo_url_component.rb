# frozen_string_literal: true

class SeoUrlComponent < ViewComponent::Base
  attr_reader :taxon
  
  def initialize(taxon)
    @taxon = taxon
  end

  def call
    nested_taxons_path(taxon.permalink)
  end
end
