module EditorJs
  module Blocks
    class Base
      InvalidBlockDataError = Class.new(StandardError)
      include ActionView::Helpers::TagHelper
      include ERB::Util

      attr_accessor :raw

      def type
        @type ||= self.class.to_s.underscore.split('/').last.gsub('_block', '')
      end

      def initialize(block_data = nil)
        @raw = cast_block_data_to_hash(block_data)
      end

      def data
        raw['data']
      end

      # Define Block JSON format
      def schema
        raise NotImplementedError
      end

      # Render HTML
      def render(options = {})
        raise NotImplementedError
      end

      # Validate block data
      def valid?
        JSON::Validator.validate(schema, raw)
      end

      # Render plain text, for full-text searching
      def plain
        @block_data
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

      def output_buffer=(value)
        @output_buffer = value
      end

      def output_buffer
        @output_buffer
      end
    end
  end
end
