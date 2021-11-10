# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  attr_reader :filter, :search_params

  def initialize(filter:, search_params:)
    @filter = filter
    @search_params = search_params
  end

  def call
    title = filter[:name]
    base_class = 'filter'

    filter_list = filter_list(filter, "#{base_class}__list", search_params)

    if filter_list.present?
      contents = []
      contents << content_tag(:h6, title, class: "#{base_class}__title") if title
      contents << filter_list
      safe_join(contents)
    end
  end

  private

  def filter_list(filter, css_class, search_params)
    labels = filter[:labels] || filter[:conds].map {|m,c| [m,m]}
    return if labels.empty?

    content_tag :ul, class: css_class do
      labels.each do |name, value|
        label = "#{filter[:name]}_#{name}".gsub(/\s+/,'_')
        checked = search_params &&
          search_params[filter[:scope]] &&
          search_params[filter[:scope]].include?(value.to_s) ? true : false

        concat filter_list_item(filter, checked, label, value, name)
      end
    end
  end

  def filter_list_item(filter, checked, label, value, name)
    content_tag :li do
      concat check_box_tag(
        "search[#{filter[:scope].to_s}][]",
        value,
        checked,
        id: label)

      # concat label_tag(label, name)
      concat ("<label for='#{label}'>#{name}</label>").html_safe
    end
  end
end
