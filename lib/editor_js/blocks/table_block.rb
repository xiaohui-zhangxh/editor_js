# frozen_string_literal: true

module EditorJs
  module Blocks
    class TableBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            content:
              type: array
              items:
                type: array
                items:
                  type: string
        YAML
      end

      def render(_options = {})
        content_tag(:div, class: css_name) do
          content_tag(:table) do
            data['content'].map do |row|
              content_tag(:tr) do
                row.map { |col| content_tag :td, col.html_safe }.join().html_safe
              end
            end.join().html_safe
          end
        end
      end

      def sanitize!
        safe_tags = {
          'b' => nil,
          'i' => nil,
          'u' => ['class'],
          'del' => ['class'],
          'a' => ['href'],
          'mark' => ['class'],
          'code' => ['class'],
          'br' => nil
        }

        data['content'] = data['content'].map do |row|
          row = (row || []).map do |cell_value|
            Sanitize.fragment(
              cell_value,
              elements: safe_tags.keys,
              attributes: safe_tags.select {|k, v| v},
              remove_contents: false
            )
          end
        end
      end

      def plain
        str = data['content'].flatten.join(', ')
        decode_html Sanitize.fragment(str).gsub(/(, )+/, ', ').strip
      end
    end
  end
end
