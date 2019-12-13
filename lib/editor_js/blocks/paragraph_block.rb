# frozen_string_literal: true

module EditorJs
  module Blocks
    class ParagraphBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            text:
              type: string
        YAML
      end

      def render(_options = {})
        content_tag(:p, class: css_name) { data['text'].html_safe }
      end

      def sanitize!
        safe_tags = {
          'b' => nil,
          'i' => nil,
          'a' => ['href'],
          'mark' => ['class'],
          'code' => ['class']
        }

        data['text'] = Sanitize.fragment(
          data['text'],
          elements: safe_tags.keys,
          attributes: safe_tags.select {|k, v| v}
        )
      end

      def plain
        decode_html(Sanitize.fragment data['text']).strip
      end
    end
  end
end
