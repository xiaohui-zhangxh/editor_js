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
          required:
          - text
          - level
        YAML
      end

      def render(_options = {})
        content_tag(:"h#{data['level'])}", class: css_name) do
          data['text'].html_safe
        end
      end

      def sanitize!
        data['text'] = Sanitize.fragment(data['text']).strip
      end

      def plain
        decode_html data['text'].strip
      end
    end
  end
end
