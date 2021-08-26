# frozen_string_literal: true

require_relative 'marker_namespace'

module SolidusStarterFrontend
  class DisableCode
    attr_reader :generator, :namespace, :path

    def initialize(generator:, namespace:, path:)
      @generator = generator
      @namespace = namespace
      @path = path
    end

    def call
      delete_lines
      delete_blocks
    end

    private

    def delete_lines
      marker_namespace.line_markers.each do |line_marker|
        generator.gsub_file path, /.*#{line_marker}\n?/, ''
      end
    end

    def delete_blocks
      non_greedy_content_regex_string = "(?:.*?)"

      marker_namespace.block_marker_pairs.each do |block_marker_pair|
        delete_block_regex_string =
          "(?: *)#{block_marker_pair[:start]}" +
          non_greedy_content_regex_string +
          "#{block_marker_pair[:end]}\n?"

        delete_block_regex =
          Regexp.new(delete_block_regex_string, Regexp::MULTILINE)

        generator.gsub_file path, delete_block_regex, ""
      end
    end

    def marker_namespace
      @marker_namespace ||= MarkerNamespace.new(namespace)
    end
  end
end
