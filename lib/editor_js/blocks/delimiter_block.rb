# frozen_string_literal: true

module EditorJs
  module Blocks
    # delimiter block
    class DelimiterBlock < Base
      def schema
        YAML.safe_load(<<~YAML)
          type: object
          additionalProperties: false
        YAML
      end

      def render(_options = {})
        content_tag :hr, '', class: css_name
      end

      def plain
        ''
      end
    end
  end
end
