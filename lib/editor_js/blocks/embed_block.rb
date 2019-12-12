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
              type:
              - number
              - string
            service:
              type: string
            source:
              type: string
            width:
              type:
              - number
              - string
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

      def plain
        Sanitize.fragment(data['caption']).strip
      end
    end
  end
end
