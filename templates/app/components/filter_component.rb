# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  BASE_CLASS = 'filter'.freeze
  CSS_CLASS = "#{BASE_CLASS}__list".freeze

  attr_reader :filter, :search_params

  def initialize(filter:, search_params:)
    @filter = filter
    @search_params = search_params
  end

  def call
    title = filter[:name]

    if filter_list.present?
      contents = []
      contents << content_tag(:h6, title, class: "#{BASE_CLASS}__title") if title
      contents << filter_list
      safe_join(contents)
    end
  end

  private

  def filter_list
    return @filter_list if @filter_list

    labels = filter[:labels] || filter[:conds].map {|m,c| [m,m]}
    return if labels.empty?

    @filter_list = content_tag :ul, class: CSS_CLASS do
      labels.each do |name, value|
        label = "#{filter[:name]}_#{name}".gsub(/\s+/,'_')
        checked = search_params &&
          search_params[filter[:scope]] &&
          search_params[filter[:scope]].include?(value.to_s) ? true : false

        concat filter_list_item(checked, label, value, name)
      end
    end
  end

  def filter_list_item(checked, label, value, name)
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
