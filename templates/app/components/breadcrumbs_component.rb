# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  SEPARATOR = '&nbsp;&raquo;&nbsp;'.freeze
  BASE_CLASS = 'breadcrumbs'.freeze

  attr_reader :taxon

  def initialize(taxon)
    @taxon = taxon
  end

  def call
    return if current_page?('/') || taxon.nil?

    content_tag(:div, class: BASE_CLASS) do
      content_tag(:nav, class: breadcrumb_class) do
        content_tag(:ol, itemscope: '', itemtype: 'https://schema.org/BreadcrumbList') do
          raw(items.map(&:mb_chars).join)
        end
      end
    end
  end

  private

  def items
    crumbs.map.with_index do |crumb, index|
      content_tag(:li, itemprop: 'itemListElement', itemscope: '', itemtype: 'https://schema.org/ListItem') do
        link_to(crumb.last, itemprop: 'item') do
          content_tag(:span, crumb.first, itemprop: 'name') +
            tag('meta', { itemprop: 'position', content: (index + 1).to_s }, false, false)
        end + (crumb == crumbs.last ? '' : raw(SEPARATOR))
      end
    end
  end

  def crumbs
    return @crumbs if @crumbs

    @crumbs = [[t('spree.home'), helpers.spree.root_path]]
    @crumbs << [t('spree.products'), helpers.spree.products_path]

    if taxon
      @crumbs += taxon.ancestors.map { |ancestor| [ancestor.name, helpers.spree.nested_taxons_path(ancestor.permalink)] }
      @crumbs << [taxon.name, helpers.spree.nested_taxons_path(taxon.permalink)]
    end

    @crumbs
  end

  def breadcrumb_class
    "#{BASE_CLASS}__content"
  end
end
