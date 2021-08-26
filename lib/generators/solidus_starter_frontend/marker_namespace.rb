# frozen_string_literal: true

module SolidusStarterFrontend
  class MarkerNamespace
    attr_reader :namespace

    def initialize(namespace)
      @namespace = namespace
    end

    def line_markers
      [
        "<%# #{marker_name('line')} %>",
        ruby_line_comment
      ]
    end

    def ruby_line_comment
      "# #{marker_name('line')}"
    end

    def block_marker_pairs
      [
        erb_marker_pair,
        ruby_block_comment_pair,
        ruby_line_comment_pair
      ]
    end

    def erb_marker_pair
      { start: "<%# #{marker_name('start')} %>", end: "<%# #{marker_name('end')} %>" }
    end

    def ruby_line_comment_pair
      { start: "# #{marker_name('start')}", end: "# #{marker_name('end')}" }
    end

    def ruby_block_comment_pair
      { start: ruby_block_comment_start, end: ruby_block_comment_end }
    end

    def ruby_block_comment_start
      "=begin # #{marker_name('start')}"
    end

    def ruby_block_comment_end
      "=end # #{marker_name('end')}"
    end

    def marker_name(name)
      [namespace, name].join('/')
    end
  end
end
