# frozen_string_literal: true

module EditorJs
  module Blocks
    class ListBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            style:
              type: string
              pattern: ^(un)?ordered$
            items:
              type: array
              items:
                type: string
        YAML
      end

      def render(_options = {})
        tag = data['style'] == 'unordered' ? :ul : :ol
        content_tag(tag, class: css_name) do
          children_tag_string = ''
          data['items'].each do |v|
            children_tag_string << content_tag(:li, v.html_safe)
          end
          children_tag_string.html_safe
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
            attributes: safe_tags.select {|k, v| v}
          )
        end
      end

      def plain
        data['items'].map { |item| decode_html(item['text']).strip }.join(', ')
      end
    end
  end
end
