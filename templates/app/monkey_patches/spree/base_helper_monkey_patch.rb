# frozen_string_literal: true

require 'carmen'

module Spree
  module BaseHelper
    def link_to_cart(text = nil)
      text = text ? h(text) : t('spree.cart')
      css_class = nil

      if current_order.nil? || current_order.item_count.zero?
        text = "#{text}: (#{t('spree.empty')})"
        css_class = 'empty'
      else
        text = "#{text}: (#{current_order.item_count})  <span class='amount'>#{current_order.display_total.to_html}</span>"
        css_class = 'full'
      end

      link_to text.html_safe, cart_path, class: "cart-info #{css_class}"
    end

    def logo(image_path = Spree::Config[:logo])
      link_to image_tag(image_path), root_path
    end

    def taxon_breadcrumbs(taxon, separator = '&nbsp;&raquo;&nbsp;', breadcrumb_class = 'inline')
      return '' if current_page?('/') || taxon.nil?

      crumbs = [[t('spree.home'), root_path]]

      crumbs << [t('spree.products'), products_path]
      if taxon
        crumbs += taxon.ancestors.collect { |ancestor| [ancestor.name, nested_taxons_path(ancestor.permalink)] } unless taxon.ancestors.empty?
        crumbs << [taxon.name, nested_taxons_path(taxon.permalink)]
      end

      separator = raw(separator)

      items = crumbs.each_with_index.collect do |crumb, index|
        content_tag(:li, itemprop: 'itemListElement', itemscope: '', itemtype: 'https://schema.org/ListItem') do
          link_to(crumb.last, itemprop: 'item') do
            content_tag(:span, crumb.first, itemprop: 'name') + tag('meta', { itemprop: 'position', content: (index + 1).to_s }, false, false)
          end + (crumb == crumbs.last ? '' : separator)
        end
      end

      content_tag(:nav, content_tag(:ol, raw(items.map(&:mb_chars).join), class: breadcrumb_class, itemscope: '', itemtype: 'https://schema.org/BreadcrumbList'), id: 'breadcrumbs', class: 'sixteen columns')
    end

    def seo_url(taxon)
      nested_taxons_path(taxon.permalink)
    end
  end
end
