# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  attr_reader :taxon, :item_classes, :separator, :separator_classes, :container_classes, :wrapper_classes

  def initialize(
    taxon:,
    item_classes: nil,
    separator: '/',
    separator_classes: nil,
    container_classes: 'flex',
    wrapper_classes: nil
  )
    @taxon = taxon
    @item_classes = item_classes
    @separator = raw(separator)
    @separator_classes = separator_classes
    @container_classes = container_classes
    @wrapper_classes = wrapper_classes
  end

  def call
    return if current_page?('/')

    content_tag(:div, class: wrapper_classes) do
      content_tag(:nav) do
        content_tag(:ol, class: container_classes, itemscope: '', itemtype: 'https://schema.org/BreadcrumbList') do
          raw(items.map(&:mb_chars).join)
        end
      end
    end
  end

  private

  def items
    crumbs.map.with_index do |crumb, index|
      content_tag(:li, itemprop: 'itemListElement', itemscope: '', itemtype: 'https://schema.org/ListItem') do
        item_link(crumb, index) + (crumb == crumbs.last ? '' : separator_item)
      end
    end
  end

  def separator_item
    content_tag(:span, separator, class: separator_classes)
  end

  def item_link(crumb, index)
    link_to(crumb[:url], itemprop: 'item', class: item_classes) do
      content_tag(:span, crumb[:name], itemprop: 'name') +
        tag('meta', { itemprop: 'position', content: (index + 1).to_s }, false, false)
    end
  end

  def crumbs
    return @crumbs if @crumbs

    @crumbs = [
      { name: t('spree.home'), url: helpers.root_path },
      { name: t('spree.products'), url: helpers.products_path }
    ]

    if(taxon)
      @crumbs += taxon.ancestors.map do |ancestor|
        { name: ancestor.name, url: helpers.nested_taxons_path(ancestor.permalink) }
      end

      @crumbs << { name: taxon.name, url: helpers.nested_taxons_path(taxon.permalink) }
    end

    @crumbs
  end
end
