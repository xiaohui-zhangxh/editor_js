# frozen_string_literal: true

module EditorJS
  module Renderer
    class BlockBase
      extend Forwardable
      attr_reader :options
      def initialize(html_sanitizer:, html_decoder:, text_sanitizer:, **options)
        @html_sanitizer = html_sanitizer
        @text_sanitizer = text_sanitizer
        @html_decoder = html_decoder
        @options = self.class.default_options.merge(options)
      end

      def self.default_options
        {}
      end

      def self.default_html_sanitizer_options
        {}
      end

      def self.default_text_sanitizer_options
        {}
      end

      def render_html(_block,
                      tag_helper:) # rubocop: disable Lint/UnusedMethodArgument
        raise NotImplementedError
      end

      def render_text(_block)
        raise NotImplementedError
      end

      private

      def decode_html(text)
        @html_decoder.decode(text)
      end

      def sanitize_html(html)
        Utils.possible_html_safe(@html_sanitizer.sanitize(html))
      end

      def sanitize_text(text)
        @text_sanitizer.sanitize(text)
      end
    end
  end
end
