# frozen_string_literal: true

require 'carmen'

module Spree
  module BaseHelper
    def logo(image_path = Spree::Config[:logo])
      link_to image_tag(image_path), root_path
    end

    def seo_url(taxon)
      nested_taxons_path(taxon.permalink)
    end
  end
end
