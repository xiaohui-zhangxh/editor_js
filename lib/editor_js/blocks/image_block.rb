# frozen_string_literal: true

module EditorJs
  module Blocks
    class ImageBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            caption:
              type: string
            url:
              type: string
            stretched:
              type: boolean
            withBackground:
              type: boolean
            withBorder:
              type: boolean
          required:
          - url
        YAML
      end

      def render(_options = {})
        content_tag :div, class: css_name do
          url = data['url']
          caption = data['caption']
          withBorder = data['withBorder']
          withBackground = data['withBackground']
          stretched = data['stretched']

          html_class = 'simple-image__picture'
          html_class << ' simple-image__picture--stretched' if stretched
          html_class << ' simple-image__picture--with-background' if withBackground
          html_class << ' simple-image__picture--with-border' if withBorder

          html_str =  content_tag :div, class: html_class do
                        content_tag :img, '', src: url
                      end
          html_str << content_tag(:div, caption.html_safe, class: 'simple-image__caption').html_safe
        end
      end

      def sanitize!
        data['caption'] = Sanitize.fragment(data['caption'])
      end

      def plain
        decode_html data['caption'].strip
      end
    end
  end
end
