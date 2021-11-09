# frozen_string_literal: true

module EditorJs
  module Blocks
    # list block
    class ListBlock < Base
      LIST_STYLES = {
        ol: %w[1 a i].freeze,
        ul: %w[disc circle square].freeze
      }.freeze

      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            style:
              type: string
              pattern: ^(un)?ordered$
            items:
              oneOf:
                - $ref: "#/definitions/list"
                - $ref: "#/definitions/nestedList"
          definitions:
            list:
              type: array
              items:
                type: string
            nestedList:
              type: array
              items:
                $ref: "#/definitions/nestedItems"
            nestedItems:
              type: object
              properties:
                content:
                  type: string
                items:
                  type: array
                  items:
                    $ref: "#/definitions/nestedItems"
                  minItems: 0
        YAML
      end

      def render(_options = {})
        content_tag(list_tag, class: css_name, type: list_style(0)) do
          data['items'].map { |item| render_item(item) }.join.html_safe
        end
      end

      def plain
        data['items'].map { |item| plain_item(item) }.join(', ')
      end

      def sanitize!
        data['items'] = data['items'].map { |item| sanitize_item!(item) }
      end

      private

      def render_item(item, level = 1)
        if nested?
          if item['items'].blank?
            return content_tag(:li, item['content'].html_safe)
          end

          list = content_tag(list_tag, class: css_name, type: list_style(level)) do
            item['items'].map { |i| render_item(i, level + 1) }.join.html_safe
          end
          return content_tag(:li, (item['content'] + list).html_safe)
        end

        content_tag(:li, item.html_safe)
      end

      def plain_item(item)
        if nested?
          return [
            decode_html(Sanitize.fragment(item['content'])).strip,
            item['items'].map { |i| plain_item(i) }.join(', ')
          ].reject(&:empty?).join(', ')
        end

        decode_html(Sanitize.fragment(item)).strip
      end

      def sanitize_item!(item)
        if nested?
          # recursively sanitize nested item nodes
          item['content'] = Sanitize.fragment(
            item['content'],
            elements: safe_tags.keys,
            attributes: safe_tags.select { |_k, v| v },
            remove_contents: true
          )
          item['items'] = item['items'].map { |nested| sanitize_item!(nested) }
          return item
        end

        Sanitize.fragment(
          item,
          elements: safe_tags.keys,
          attributes: safe_tags.select { |_k, v| v },
          remove_contents: true
        )
      end

      def list_tag
        data['style'] == 'unordered' ? :ul : :ol
      end

      def nested?
        return @nested if defined? @nested

        @nested = data['items'].first.class != String
      end

      def safe_tags
        {
          'b' => nil,
          'i' => nil,
          'u' => ['class'],
          'del' => ['class'],
          'a' => ['href'],
          'mark' => ['class'],
          'code' => ['class']
        }
      end

      def list_style(level)
        LIST_STYLES[list_tag][level % 3]
      end
    end
  end
end
