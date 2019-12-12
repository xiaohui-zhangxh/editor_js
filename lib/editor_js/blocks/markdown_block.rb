# frozen_string_literal: true

module EditorJs
  module Blocks
    class HTMLwithCodeRay < Redcarpet::Render::HTML
      def block_code(code, language)
        CodeRay.scan(code, language || :text).div(css: :class)
      end

      def list_item(text, list_type)
        if text.start_with?("[x]", "[X]")
          text[0..2] = %(<input type='checkbox' checked='checked' disabled>)
        elsif text.start_with?("[ ]")
          text[0..2] = %(<input type='checkbox' disabled>)
        end
        %(<li>#{text}</li>)
      end
    end

    class MarkdownBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
          properties:
            text:
              type: string
        YAML
      end

      def render(_options = {})
        content_tag :div, class: "#{css_name} markdown-block markdown-body" do
          content_text = data['text'] || ''

          render_options = {
            escape_html: true,
            hard_wrap: true,
            with_toc_data: true,
            link_attributes: { rel: 'nofollow', target: '_blank' }
          }
          renderer = HTMLwithCodeRay.new(render_options)

          options = {
            autolink: true,
            fenced_code_blocks: true,
            lax_spacing: true,
            no_intra_emphasis: true,
            strikethrough: true,
            tables: true,
            superscript: true,
            highlight: true,
            quote: true,
            footnotes: true
          }
          markdown_to_html = Redcarpet::Markdown.new(renderer, options)

          markdown_to_html.render(content_text).html_safe
        end
      end

      def plain
        data['text'].strip
      end
    end
  end
end
