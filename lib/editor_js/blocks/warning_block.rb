# frozen_string_literal: true

module EditorJs
  module Blocks
    # warning block
    class WarningBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            title:
              type: string
            message:
              type: string
        YAML
      end

      def render(_options = {})
        title = data['title'].html_safe
        message = data['message'].html_safe

        content_tag :div, class: css_name do
          html_str = content_tag :div, title, class: "#{css_name}__title"
          html_str << content_tag(:div, message, class: "#{css_name}__message")
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
          'code' => ['class']
        }
      end

      def sanitize!
        %w[title message].each do |key|
          data[key] = Sanitize.fragment(
            data[key],
            elements: safe_tags.keys,
            attributes: safe_tags.select { |_k, v| v },
            remove_contents: false
          )
        end
      end

      def plain
        string = [
          Sanitize.fragment(data['title']).strip,
          Sanitize.fragment(data['message']).strip
        ].join(', ')
        decode_html(string)
      end
    end
  end
end
