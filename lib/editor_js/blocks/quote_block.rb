# frozen_string_literal: true

module EditorJs
  module Blocks
    class QuoteBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            text:
              type: string
            caption:
              type: string
            alignment:
              type: string
        YAML
      end

      def render(_options = {})
        content_tag :div, class: css_name do
          data['items'].each do |item|
            concat content_tag(:input, item['text'], type: 'checkbox', disabled: true, checked: item['checked'])
          end
        end
      end

      def sanitize!
        safe_tags = {
          'b' => nil,
          'i' => nil,
          'a' => ['href'],
          'mark' => ['class'],
          'code' => ['class']
        }

        %w(text caption).each do |key|
          data[key] = Sanitize.fragment(
            data[key],
            elements: safe_tags.keys,
            attributes: safe_tags.select {|k, v| v}
          )
        end
        data['alignment'] = Sanitize.fragment data['alignment']
      end

      def plain
        str = [data['text']&.strip, data['caption']&.strip].join(', ')
        decode_html(str)
      end
    end
  end
end
