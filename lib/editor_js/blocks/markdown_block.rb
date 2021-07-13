# frozen_string_literal: true
require 'katex'

module EditorJs
  module Blocks
    # markdown block
    class MarkdownBlock < Base
      class HTMLwithCodeRay < Redcarpet::Render::HTML
        include ActionView::Helpers::TagHelper

        def block_code(code, language)
          if language.in?(%w[math latex])
            %(<div class='math-block'>#{Katex.render(code, display_mode: false) rescue code}</div>)
          else
            CodeRay.scan(code, language || :text).div(css: :class)
          end
        end

        def paragraph(text)
          %(<p>#{text_to_latex_html(text)}</p>)
        end

        def header(text, header_level)
          content_tag(:"h#{header_level}", text_to_latex_html(text).html_safe)
        end

        # $$ :block
        # $  :inline
        def text_to_latex_html(text, block = true)
          if block
            text =~ /(\$\$[^\s][^\n]+[^\s]\$\$)/
            str = $1
            text_to_latex_html(text, false) if str.nil?

            latex_str = str.sub(/^\$\$/, '')
            latex_str = latex_str.sub(/\$\$$/, '')
            text.sub!(str, Katex.render(latex_str.html_safe, display_mode: true))
            text_to_latex_html(text)
          else
            text =~ /(\$[^\s][^\n]+[^\s]\$)/
            str = $1
            text if str.nil?

            latex_str = str.sub(/^\$/, '')
            latex_str = latex_str.sub(/\$$/, '')
            text.sub!(str, Katex.render(latex_str.html_safe, display_mode: false))
            text_to_latex_html(text, false)
          end
        rescue
          text
        end

        def list_item(text, list_type)
          if text.start_with?("[x]", "[X]")
            text[0..2] = %(<input type='checkbox' checked='checked' disabled>)
          elsif text.start_with?("[ ]")
            text[0..2] = %(<input type='checkbox' disabled>)
          end
          %(<li>#{text}</li>)
        end

        def codespan(code)
          if code.start_with?("$$") and code.end_with?("$$")
            code.gsub!(/\$\$/, '\$\$')
          end
          %(<code>#{code}</code>)
        end
      end

      def sanitize!; end

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
        content_tag :div, class: css_name do
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
            superscript: false,
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
