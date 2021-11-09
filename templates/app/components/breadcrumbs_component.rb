# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  attr_reader :taxon

  def initialize(taxon)
    @taxon = taxon
  end

  def call
    separator = '&nbsp;&raquo;&nbsp;'
    base_class = 'breadcrumbs'

    breadcrumbs = breadcrumbs(taxon, separator, "#{base_class}__content")

    if breadcrumbs.present?
      content_tag(:div, breadcrumbs, class: base_class)
    end
  end

  private

  def breadcrumbs(taxon, separator, breadcrumb_class = 'inline')
    return '' if current_page?('/') || taxon.nil?

    crumbs = [[t('spree.home'), helpers.spree.root_path]]

    crumbs << [t('spree.products'), helpers.spree.products_path]
    if taxon
      crumbs += taxon.ancestors.collect { |ancestor| [ancestor.name, helpers.spree.nested_taxons_path(ancestor.permalink)] }
      crumbs << [taxon.name, helpers.spree.nested_taxons_path(taxon.permalink)]
    end

    separator = raw(separator)

    items = crumbs.each_with_index.collect do |crumb, index|
      content_tag(:li, itemprop: 'itemListElement', itemscope: '', itemtype: 'https://schema.org/ListItem') do
        link_to(crumb.last, itemprop: 'item') do
          content_tag(:span, crumb.first, itemprop: 'name') + tag('meta', { itemprop: 'position', content: (index + 1).to_s }, false, false)
        end + (crumb == crumbs.last ? '' : separator)
      end
    end

    content_tag(
      :nav,
      content_tag(
        :ol,
        raw(items.map(&:mb_chars).join),
        itemscope: '',
        itemtype: 'https://schema.org/BreadcrumbList'),
      class: breadcrumb_class
    )
  end
end
