# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  BASE_CLASS = 'filter'.freeze
  CSS_CLASS = "#{BASE_CLASS}__list".freeze

  attr_reader :filter, :search_params

  def initialize(filter:, search_params:)
    @filter = filter
    @search_params = search_params || {}
  end

  def call
    return unless filter_list

    contents = []
    contents << content_tag(:h6, title, class: "#{BASE_CLASS}__title") if title
    contents << filter_list

    safe_join(contents)
  end

  private

  def filter_list
    return @filter_list if @filter_list
    return if labels.empty?

    @filter_list = content_tag :ul, class: CSS_CLASS do
      safe_join(labels.map { |name, value| filter_list_item(value, name) })
    end
  end

  def filter_list_item(value, name)
    id = filter_list_item_id(name)

    content_tag :li do
      concat check_box_tag(
        "search[#{filter[:scope].to_s}][]",
        value,
        filter_list_item_checked?(value),
        id: id)

      # concat label_tag(label, name)
      concat ("<label for='#{id}'>#{name}</label>").html_safe
    end
  end

  def filter_list_item_id(name)
    "#{filter[:name]}_#{name}".gsub(/\s+/,'_')
  end

  def filter_list_item_checked?(value)
    search_params[filter[:scope]]&.include?(value.to_s)
  end

  def title
    filter[:name]
  end

  def labels
    @labels ||= filter[:labels] || filter[:conds].map { |m,c| [m,m] }
  end
end
