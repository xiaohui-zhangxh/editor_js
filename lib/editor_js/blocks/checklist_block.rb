# frozen_string_literal: true

module EditorJs
  module Blocks
    class ChecklistBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            items:
              type: array
              items:
                type: object
                additionalProperties: false
                properties:
                  text:
                    type: string
                  checked:
                    type: boolean
                required:
                - text
        YAML
      end

      def render(_options = {})
        content_tag :div, class: css_name do
          data['items'].each do |item|
            concat content_tag(:input, item['text'], type: 'checkbox', disabled: true, checked: item['checked'])
          end
        end
      end

      def plain
        data['items'].map { |item| Sanitize.fragment(item['text']).strip }.join(', ')
      end
    end
  end
end
