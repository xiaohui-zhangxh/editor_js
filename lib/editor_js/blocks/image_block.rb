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

          html_class = "#{css_name}__picture"
          html_class += " #{css_name}__picture--stretched" if stretched
          html_class += " #{css_name}__picture--with-background" if withBackground
          html_class += " #{css_name}__picture--with-border" if withBorder

          html_str =  content_tag :div, class: html_class do
                        content_tag :img, '', src: url
                      end
          html_str << content_tag(:div, caption.html_safe, class: "#{css_name}__caption").html_safe
        end
      end

      def sanitize!
        %w[caption url].each do |key|
          str = Sanitize.fragment(data[key], remove_contents: true).strip
          if key == 'url'
            str.gsub('&amp;', '&')
          end
          data[key] = str
        end
      end

      def plain
        decode_html data['caption'].strip
      end
    end
  end
end
