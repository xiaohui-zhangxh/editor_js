# frozen_string_literal: true

module EditorJs
  module Blocks
    class HeaderBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            text:
              type: string
            level:
              type: number
              enum: [1,2,3,4,5,6]
          required:
          - text
          - level
        YAML
      end

      def render(_options = {})
        content_tag(:"h#{data['level']}", data['text'].html_safe, class: css_name)
      end

      def sanitize!
        data['text'] = Sanitize.fragment(data['text'], remove_contents: true).strip
      end

      def plain
        decode_html data['text'].strip
      end
    end
  end
end
