require 'common_marker/custom_html_render'

# frozen_string_literal: true
module CommonMarker
  # rouge
  module Rouge
    module_function

    def render_doc(text, cmark_options = :DEFAULT, extensions = [], **cmr_options)
      cmark = cmr_options[:cmark_class] || ::CommonMarker

      ast = cmark.render_doc(text, cmark_options, extensions)
      process_ast(ast, cmr_options)
      ast
    end

    def render_html(text, cmark_options = :DEFAULT, render_options = :UNSAFE, extensions = [], **cmr_options)
      doc = render_doc(text, cmark_options, extensions, **cmr_options)
      CommonMarker::CustomHtmlRenderer.new(options: render_options, extensions: extensions).render(doc)
      # doc.to_html(render_options)
    end

    def process_ast(ast, cmr_options)
      sanitize_options = {
        remove_contents: true,
        attributes: {
          'a' => ['href', 'target'],
          'ul' => ['type']
        },
        protocols: {
          'a' => {'href' => ['http', 'https', 'mailto']}
        }
      }
      ast.walk do |node|
        if node.type == :code_block
          next if node.fence_info == ''

          source = node.string_content

          lexer = ::Rouge::Lexer.find_fancy(node.fence_info) || ::Rouge::Lexers::PlainText.new

          formatter_class = cmr_options[:formatter_class]
          formatter       = cmr_options[:formatter]

          # support format accepting class for a time being
          if formatter.is_a? Class
            formatter_class ||= formatter
            formatter = nil
          end

          formatter_class ||= ::Rouge::Formatters::HTML

          formatter ||= formatter_class.new(cmr_options[:options] || {})

          html = '<div class="highlighter-rouge language-' + CGI.escapeHTML(node.fence_info) + '">' + formatter.format(lexer.lex(source)) + '</div>'

          new_node = ::CommonMarker::Node.new(:html)
          new_node.string_content = html

          node.insert_before(new_node)
          node.delete
        elsif node.type == :html
          node.string_content = ::Sanitize.fragment(
            node.string_content,
            ::Sanitize::Config.merge(
              ::Sanitize::Config::BASIC,
              sanitize_options
            )
          )
        elsif node.type == :inline_html
          node_text = node.next
          node_end  = node_text&.next
          if node_text&.type == :text && node_end&.type == :inline_html
            html_str = node.string_content + node_text.string_content + node_end.string_content
            node_text.string_content = ''
            node_end.string_content = ''
          else
            html_str = node.string_content
          end
          node.string_content = ::Sanitize.fragment(
            html_str,
            ::Sanitize::Config.merge(
              ::Sanitize::Config::BASIC,
              sanitize_options
            )
          )
        end
      end
    end

    private_class_method :process_ast
  end
end
