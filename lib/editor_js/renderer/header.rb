# frozen_string_literal: true

module EditorJS
  module Renderer
    class Header < BlockBase
      def self.default_options
        { class_name: 'block__header' }
      end

      def self.default_html_sanitizer_options
        {}
      end

      def initialize(**options)
        super(html_sanitizer: nil, text_sanitizer: nil, html_decoder: nil, **options)
      end

      def render_html(block, tag_helper:)
        return '' if Utils.blank?(block.data[:text])

        alignment_class = block.data[:alignment] ? "header--#{block.data[:alignment]}" : nil
        tag_helper.content_tag "h#{block.data[:level]}", class: [options[:class_name], alignment_class] do
          sanitize_html(block.data[:text])
        end
      end

      def render_text(block)
        return '' if Utils.blank?(block.data[:text])

        text = sanitize_text(block.data[:text])
        decode_html(text).rstrip
      end
    end
  end
end
