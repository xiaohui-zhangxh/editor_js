# frozen_string_literal: true

module EditorJs
  module Blocks
    # header_block
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
            alignment:
              type: string
              enum:
                - align-left
                - align-center
                - align-right
          required:
          - text
          - level
        YAML
      end

      def render(_options = {})
        alignment = data['alignment']
        class_name_str = css_name
        if alignment.present?
          class_name_str = [
            class_name_str,
            css_name("__#{alignment}")
          ].join(' ')
        end
        content_tag(:"h#{data['level']}", data['text'].html_safe, class: class_name_str)
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
