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
          # 按code标签分割，若为非code标签的文本提取公式
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

        # 从非code标签中提取公式
        def match_latex_code_to_html(text, block = true)
          return text if text.start_with?('<code>') && text.end_with?('</code>')

          if block
            # 匹配$$ $$间的字符，并中间不可包含换行符，$不为\$
            text =~ /(\$\$[^\n|\$\$]+\$\$)/
            str = Regexp.last_match(1)
            if str.nil? || str.include?('<code>')
              return match_latex_code_to_html(text, false)
            end

            # 去掉$，内容已经提取出来，由替代标签包裹
            latex_str = str.sub(/^\$\$/, '')
            latex_str = latex_str.sub(/\$\$$/, '')
            text.sub!(str, math_block_tag(latex_str))
            match_latex_code_to_html(text)
          else
            # 匹配$ $间的字符，并中间不可包含换行符, $不为\$
            text =~ /[^\\]?(\$[^\n|\$]+\$)/
            str = Regexp.last_match(1)
            return text if str.nil? || str.include?('<code>')

            # 去掉$，内容已经提取出来，由替代标签包裹
            latex_str = str.sub(/^\$/, '')
            latex_str = latex_str.sub(/\$$/, '')
            text.sub!(str, math_block_tag(latex_str, false))
            match_latex_code_to_html(text, false)
          end
        end

        # 使用特定标签包裹公式，便于前端提取渲染
        # 由于会在前端浏览器中渲染，防止浏览器渲染公式代码 所以url_encode一下
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

      # 输入非``` `包裹的文本数据
      # 输出转换斜线，由于Redcarpet处理斜线有问题和输出到前端的斜线期望原样输出
      # 例如: 用户输入：$\tiny 萌萌哒\\$ -> markdown_block得到的： "\\tiny 萌萌哒\\\\" -> 期望输出："\\tiny 萌萌哒\\\\"
      # 但在markdown_block得到的后在Redcarpet转换时会出现问题，所以需要把斜线转换一下
      def math_str_encode(text)
        # 匹配
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
          # 按``` `包裹的文本数据拆分为数组，
          # ``` `包裹的不做处理，其他的处理公式内斜线问题
          content_text = content_text.split(/(```.*```|`[^\n]*`)/).map do |str|
            # 匹配非``` `包裹的文本数据
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
