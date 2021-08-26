# frozen_string_literal: true

require_relative 'marker_namespace'

module SolidusStarterFrontend
  class EnableCode
    attr_reader :generator, :namespace, :path

    def initialize(generator:, namespace:, path:)
      @generator = generator
      @namespace = namespace
      @path = path
    end

    def call
      uncomment_ruby_lines
      uncomment_ruby_blocks
    end

    private

    def uncomment_ruby_lines
      generator.gsub_file path, /# (.*?) #{marker_namespace.ruby_line_comment}/, '\1'
    end

    def uncomment_ruby_blocks
      non_greedy_content = "(.*?)"

      uncomment_block_regex_string =
        "#{marker_namespace.ruby_block_comment_start}\n" +
        non_greedy_content +
        "#{marker_namespace.ruby_block_comment_end}\n?"

      uncomment_block_regex = Regexp.new(uncomment_block_regex_string, Regexp::MULTILINE)

      generator.gsub_file path, uncomment_block_regex, '\1'
    end

    def marker_namespace
      @marker_namespace ||= MarkerNamespace.new(namespace)
    end
  end
end
