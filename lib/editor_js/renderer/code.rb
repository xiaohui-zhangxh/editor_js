# frozen_string_literal: true

module EditorJS
  module Renderer
    class Code < BlockBase
      def self.default_options
        { class_name: 'block__code',
          tag_name: 'code' }
      end

      def self.default_html_sanitizer_options
        {}
      end

      def initialize(**options)
        super(html_sanitizer: nil, text_sanitizer: nil, html_decoder: nil, **options)
      end

      def render_html(block, tag_helper:)
        return '' if Utils.blank?(block.data[:code])

        tag_helper.content_tag options[:tag_name], class: options[:class_name] do
          block.data[:code]
        end
      end

      def render_text(block)
        return '' if Utils.blank?(block.data[:code])

        block.data[:code].rstrip
      end
    end
  end
end
