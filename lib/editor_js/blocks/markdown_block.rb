# frozen_string_literal: true

module EditorJs
  module Blocks
    # markdown block
    class MarkdownBlock < Base
      class HTMLwithCodeRay < Redcarpet::Render::HTML
        include ActionView::Helpers::TagHelper
        include ERB::Util

        def block_code(code, language)
          if %w[math latex].include?(language)
            math_block_tag(code)
          else
            CodeRay.scan(code, language || :text).div(css: :class)
          end
        end

        def paragraph(text)
          str = text.split(%r{(<code>.+<\/code>)}).map do |x|
            match_latex_code_to_html(x)
          end.join

          %(<p>#{str}</p>)
        end

        def header(text, header_level)
          content_tag(:"h#{header_level}", match_latex_code_to_html(text).html_safe)
        end

        def list_item(text, _list_type)
          text = text.split(%r{(<code>.+<\/code>)}).map do |x|
            match_latex_code_to_html(x)
          end.join

          if text.start_with?('[x]', '[X]')
            text[0..2] = %(<input type='checkbox' checked='checked' disabled>)
          elsif text.start_with?('[ ]')
            text[0..2] = %(<input type='checkbox' disabled>)
          end
          %(<li>#{text}</li>)
        end

        def match_latex_code_to_html(text, block = true)
          return text if text.start_with?('<code>') && text.end_with?('</code>')

          if block
            text =~ /(\$\$[^\n|\$\$]+\$\$)/
            str = Regexp.last_match(1)
            if str.nil? || str.include?('<code>')
              return match_latex_code_to_html(text, false)
            end

            latex_str = str.sub(/^\$\$/, '')
            latex_str = latex_str.sub(/\$\$$/, '')
            text.sub!(str, math_block_tag(latex_str))
            match_latex_code_to_html(text)
          else
            text =~ /[^\\]?(\$[^\n|\$]+\$)/
            str = Regexp.last_match(1)
            return text if str.nil? || str.include?('<code>')

            latex_str = str.sub(/^\$/, '')
            latex_str = latex_str.sub(/\$$/, '')
            text.sub!(str, math_block_tag(latex_str, false))
            match_latex_code_to_html(text, false)
          end
        end

        def math_block_tag(text, block = true)
          tag = block ? :div : :span
          css_name = block ? 'markdown_math-block' : 'markdown_math-inline_block'
          content_tag(
            tag,
            url_encode(text.to_s),
            class: css_name
          )
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

      def math_str_encode(text)
        text.split(/(\$\$.*\$\$|\$[^\n]*\$)/).map do |str|
          if str.match?(/(^\$\$.*\$\$$|^\$.*\$$)/)
            str.gsub!(/\\/, '\\\\\\\\')
          end
          str
        end.join
      end

      def render(_options = {})
        content_tag :div, class: css_name do
          content_text = data['text'] || ''
          content_text = content_text.split(/(```.*```|`[^\n]*`)/).map do |str|
            str = math_str_encode(str) unless str.match?(/(^```.*```$|^`.*`$)/)
            str
          end.join
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
