# frozen_string_literal: true

module EditorJs
  module Blocks
    class EmbedBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            caption:
              type: string
            embed:
              type: string
            height:
              type: string
            service:
              type: string
            source:
              type: string
            width:
              type: string
          required:
          - embed
          - service
          - source
          - width
          - height
        YAML
      end

      def render(options = {})
        content_tag :div, class: css_name do
          concat content_tag(:iframe, '',
                             src: data['embed'],
                             width: data['width'],
                             height: data['height'],
                             frameborder: options.fetch('frameborder', '0'),
                             allowfullscreen: options.fetch('allowfullscreen', true))
          concat content_tag(:span, data['caption'])
        end
      end

      def sanitize!
        %w[caption embed height service source width].each do |key|
          str = Sanitize.fragment(data[key], remove_contents: true).strip
          if %w[embed service source].include?(key)
            str.gsub('&amp;', '&')
          end
          data[key] = str
        end
      end

      def plain
        data['caption'].strip
      end
    end
  end
end
