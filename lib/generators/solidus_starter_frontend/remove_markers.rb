# frozen_string_literal: true

require_relative 'marker_namespace'

module SolidusStarterFrontend
  class RemoveMarkers
    attr_reader :generator, :namespace, :path

    def initialize(generator:, namespace:, path:)
      @generator = generator
      @namespace = namespace
      @path = path
    end

    def call
      remove_line_markers
      remove_block_markers
    end

    private

    def remove_line_markers
      marker_namespace.line_markers.each do |line_marker|
        generator.gsub_file path, /(?: ?)#{line_marker}/, ''
      end
    end

    def remove_block_markers
      [marker_namespace.erb_marker_pair, marker_namespace.ruby_line_comment_pair].each do |pair|
        generator.gsub_file path, /(?: *)#{pair[:start]}\n?/, ''
        generator.gsub_file path, /(?: *)#{pair[:end]}\n?/, ''
      end
    end

    def marker_namespace
      @marker_namespace ||= MarkerNamespace.new(namespace)
    end
  end
end
