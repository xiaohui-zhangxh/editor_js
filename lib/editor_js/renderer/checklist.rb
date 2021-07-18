# frozen_string_literal: true

module EditorJS
  module Renderer
    class Checklist < BlockBase
      def self.default_options
        { class_name: 'block__checklist',
          tag_name: 'ul',
          item_tag_name: 'li',
          checked_class_name: 'checklist--checked',
          delimiter: ', ' }
      end

      def self.default_html_sanitizer_options
        {
          elements: %w[b i u del a mark code],
          attributes: {
            'u' => ['class'],
            'del' => ['class'],
            'a' => ['href'],
            'mark' => ['class'],
            'code' => ['class']
          }
        }
      end

      def render_html(block, tag_helper:)
        wrapper_html(block, tag_helper) do |item|
          item_html(item, tag_helper)
        end
      end

      def render_text(block)
        block.data[:items].map do |item|
          text = item[:text]
          text = sanitize_text(text)
          decode_html(text).strip
        end.join(options[:delimiter])
      end

      private

      def wrapper_html(block, tag_helper, &blk)
        tag_helper.content_tag options[:tag_name], class: options[:class_name] do
          Utils.possible_html_safe("\n" + block.data[:items].map(&blk).join("\n") + "\n")
        end
      end

      def item_html(item, h)
        h.content_tag options[:item_tag_name], class: item[:checked] ? options[:checked_class_name] : nil do
          input_html = h.content_tag(:input, nil,
                                     type: 'checkbox',
                                     disabled: true,
                                     checked: item[:checked])
          html = "#{input_html} #{sanitize_html(item[:text])}".rstrip
          Utils.possible_html_safe(html)
        end
      end
    end
  end
end
