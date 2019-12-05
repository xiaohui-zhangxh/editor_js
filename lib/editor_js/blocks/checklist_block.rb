# frozen_string_literal: true

module EditorJs
  module Blocks
    class ChecklistBlock < Base
      def schema
        { type: 'object',
          additionalProperties: false,
          properties: { type: { type: 'string' },
                        data: { type: 'object',
                                additionalProperties: false,
                                properties: { items: { type: 'array',
                                                       items: { type: 'object',
                                                                additionalProperties: false,
                                                                properties: { text: { type: 'string' },
                                                                              checked: { type: 'boolean' } } } } } } } }
      end

      def render(_options = {})
        content_tag :div, class: 'editor_js__checklist' do
          data['items'].map do |item|
            content_tag :input, type: 'checkbox', disabled: true, checked: item['checked'] do
              item['text']
            end
          end.join.html_safe
        end
      end

      def plain
        data['items'].map { |item| html_escape_once(item['text']) }.join(', ')
      end
    end
  end
end
