module EditorJS
  module Renderer
    # Renderer for invalid block
    class Invalid < BlockBase
      def initialize(**options)
        super(html_sanitizer: nil, html_decoder: nil, text_sanitizer: nil, **options)
      end

      def self.default_options
        { class_name: 'block--invalid',
          tag_name: 'div',
          message: 'Invalid block!' }
      end

      def render_html(_block, tag_helper:)
        return '' if options[:message].nil? || options[:message].strip.empty?

        tag_helper.content_tag options[:tag_name], options[:message],
                               class: options[:class_name]
      end

      def render_text(_block)
        ''
      end
    end
  end
end
