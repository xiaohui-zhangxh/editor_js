module EditorJs
  module Blocks
    class Base
      InvalidBlockDataError = Class.new(StandardError)
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper
      include ERB::Util

      # ActionView::Helpers::TagHelper requires output_buffer accessor
      attr_accessor :raw, :output_buffer

      def initialize(raw = nil)
        @raw = raw
        @content = cast_block_data_to_hash(raw.deep_dup)
        sanitize!
      end

      # Define JSON format of data
      def schema
        raise NotImplementedError
      end

      # Render HTML
      def render(_options = {})
        raise NotImplementedError
      end

      # Sanitize content of data
      def sanitize!; end

      # Render plain text, for full-text searching
      def plain; end

      # Validate data
      def valid?
        JSON::Validator.validate(schema, data)
      end

      def type
        @type ||= self.class.to_s.underscore.split('/').last.gsub('_block', '')
      end

      def data
        @content['data']
      end

      private

      def cast_block_data_to_hash(str_or_hash)
        str_or_hash = JSON.parse(str_or_hash) if str_or_hash.is_a?(String)
        str_or_hash = { 'type' => type } if str_or_hash.nil?
        raise InvalidBlockDataError, str_or_hash unless str_or_hash.is_a?(Hash)

        str_or_hash = str_or_hash.deep_stringify_keys
        raise InvalidBlockDataError, "block type <#{str_or_hash['type']}> doesn't match <#{type}>" unless str_or_hash['type'] == type

        str_or_hash
      rescue JSON::ParserError => _e
        raise InvalidBlockDataError, "Invalid JSON: #{str_or_hash}"
      end

      def css_prefix
        @css_prefix ||= "#{EditorJs.css_name_prefix}#{type}"
      end

      def css_name(name = nil)
        "#{css_prefix}#{name}"
      end

      def html_coder
        @html_coder ||= HTMLEntities.new
      end

      def decode_html(string)
        html_coder.decode(string)
      end
    end
  end
end
