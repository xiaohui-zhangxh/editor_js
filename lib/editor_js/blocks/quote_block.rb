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
        text = data['text'].html_safe
        caption = data['caption'].presence&.html_safe

        content_tag :div, class: css_name do
          html_str = content_tag :div, text, class: "#{css_name}__text"
          html_str << content_tag(:div, caption, class: "#{css_name}__caption") if caption
          html_str
        end
      end

      def safe_tags
        {
          'b' => nil,
          'i' => nil,
          'u' => ['class'],
          'del' => ['class'],
          'a' => ['href'],
          'mark' => ['class'],
          'code' => ['class'],
          'br' => nil
        }
      end

      def sanitize!
        %w[text caption].each do |key|
          data[key] = Sanitize.fragment(
            data[key],
            elements: safe_tags.keys,
            attributes: safe_tags.select { |_k, v| v },
            remove_contents: false
          )
        end
        data['alignment'] = Sanitize.fragment(data['alignment'], remove_contents: true)
      end

      def plain
        string = [
          Sanitize.fragment(data['text']).strip,
          Sanitize.fragment(data['caption']).strip
        ].join(', ')
        decode_html(string)
      end
    end
  end
end
