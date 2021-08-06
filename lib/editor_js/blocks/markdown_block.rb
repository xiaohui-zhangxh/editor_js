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

      # https://github.com/gjtorikian/commonmarker
      # https://github.github.com/gfm/#ordered-list
      # https://meta.stackexchange.com/questions/348746/were-switching-to-commonmark
      def render(options = {})
        sanitize_config = { remove_contents: true }
        sanitize_config.merge!(options.delete(:sanitize_config) || {})

        content_tag :div, class: css_name do
          content_text = data['text'] || ''

          content_text = Sanitize.fragment(
                            content_text,
                            Sanitize::Config.merge(
                              Sanitize::Config::BASIC,
                              sanitize_config
                            )
                         )

          CommonMarker.render_html(
            content_text,
            %i[DEFAULT UNSAFE GITHUB_PRE_LANG FOOTNOTES TABLE_PREFER_STYLE_ATTRIBUTES HARDBREAKS],
            %i[table strikethrough tasklist tagfilter]
          ).html_safe
        end
      end

      def plain
        data['text'].strip
      end
    end
  end
end
