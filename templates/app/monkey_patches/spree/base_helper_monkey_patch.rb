# frozen_string_literal: true

require 'carmen'

module Spree
  module BaseHelper
    def seo_url(taxon)
      nested_taxons_path(taxon.permalink)
    end
  end
end
