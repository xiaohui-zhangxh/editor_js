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
          data['items'].map do |item|
            content_tag(:div, class: css_name('__warrper')) do
              html_str = content_tag(:input, nil, type: 'checkbox', disabled: true, checked: item['checked'])
              html_str += content_tag(:label, item['text'].html_safe)
              html_str.html_safe
            end.html_safe
          end.join.html_safe
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

        data['items'].each do |item|
          item['text'] = Sanitize.fragment(
            item['text'],
            elements: safe_tags.keys,
            attributes: safe_tags.select {|k, v| v},
            remove_contents: true
          )
        end
      end

      def plain
        data['items'].map { |item| decode_html(item['text']).strip }.join(', ')
      end
    end
  end
end
