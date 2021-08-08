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
          content_text = data['text'] || ''
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
    end
  end
end
