# frozen_string_literal: true

module EditorJs
  module Blocks
    # markdown block
    class MarkdownBlock < Base
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

      # commonmarker: markdown to html
      # https://github.com/gjtorikian/commonmarker
      # https://github.github.com/gfm/#ordered-list
      # https://meta.stackexchange.com/questions/348746/were-switching-to-commonmark

      # rouge: syntax highlighter
      # https://github.com/rouge-ruby/rouge/
      # https://spsarolkar.github.io/rouge-theme-preview/
      # shell: rougify help style
      # # Get some CSS
      # Rouge::Themes::Base16.mode(:light).render(scope: '.highlight')
      # # Or use Theme#find with string input
      # Rouge::Theme.find('base16.light').render(scope: '.highlight')
      def render(_options = {})
        content_tag :div, class: css_name do
          content_text = filter_html(data['text']) || ''

          CommonMarker::Rouge.render_html(
            content_text,
            %i[UNSAFE FOOTNOTES STRIKETHROUGH_DOUBLE_TILDE],
            %i[UNSAFE GITHUB_PRE_LANG HARDBREAKS TABLE_PREFER_STYLE_ATTRIBUTES FULL_INFO_STRING FOOTNOTES],
            %i[table strikethrough tasklist tagfilter],
            formatter: Rouge::Formatters::HTMLLegacy.new(inline_theme: 'github')
          ).html_safe
        end
      end

      def plain
        data['text'].strip
      end

      private

      def filter_html(html_str)
        reg = %r{(`[^\n|```]+?`)|(\n+```.+?```)|([^\n]```[^\n]+?```)|(<code>[^\n]+?<\/code>)}m
        reg2 = %r{(?:`([^\n|```]+?)`)|(?:\n+```(.+?)```)|(?:[^\n]```([^\n]+?)```)|(?:<code>([^\n]+?)<\/code>)}m
        html_str = html_str.split(reg).map do |str|
          if str =~ reg2
            match_text = $1 || $2 || $3 || $4
            str.sub!(match_text, CGI.escapeHTML(match_text)) if match_text.present?
          end
          str
        end.join
        html_str = sanitize_html(html_str)
        html_str.split(reg).map do |str|
          if str =~ reg2
            match_text = $1 || $2 || $3 || $4
            str.sub!(match_text, CGI.unescapeHTML(match_text)) if match_text.present?
          end
          str
        end.join
      end

      def sanitize_html(html_str)
        sanitize_options = {
          remove_contents: true,
          attributes: {
            'a' => %w[href target],
            'ul' => ['type']
          },
          protocols: {
            'a' => { 'href' => %w[http https mailto] }
          }
        }
        ::Sanitize.fragment(
          html_str,
          ::Sanitize::Config.merge(::Sanitize::Config::BASIC, sanitize_options)
        )
      end
    end
  end
end
