module Buttons
  class PrimaryComponent < ActionView::Component::Base
    STYLES = [:big, :small].freeze
    TYPES = [:button, :submit].freeze

    validates :content, presence: true
    validates :disabled, inclusion: { in: [true, false] }
    validates :style, inclusion: { in: STYLES }, allow_nil: true
    validates :type, inclusion: { in: TYPES }

    def initialize(
      disabled: false,
      id: nil,
      style: nil,
      type: :button
    )
      @disabled = disabled
      @id = id
      @style = style
      @type = type
    end

    private

    attr_reader :disabled, :id, :style, :type
  end
end
