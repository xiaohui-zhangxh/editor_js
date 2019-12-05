module EditorJs
  module Blocks
    class Base
      InvalidBlockDataError = Class.new(StandardError)
      include ActionView::Helpers::TagHelper
      include ERB::Util

      attr_accessor :raw, :data

      def type
        @type ||= self.class.to_s.underscore.split('/').last.gsub('_block', '')
      end

      def initialize(block_data = nil)
        @raw = cast_block_data_to_hash(block_data)
        validates_raw!
      end

      def schema
        raise NotImplementedError
      end

      def render(options = {})
        raise NotImplementedError
      end

      def valid?
        JSON::Validator.validate(schema, raw)
      end

      def plain
        @block_data
      end

      def sanitize
        @block_data
      end

      private

      def validates_raw!
        raise InvalidBlockDataError, "block type <#{raw['type']}> doesn't match <#{type}>" unless raw['type'] == type

        @data = raw['data']
      end

      def cast_block_data_to_hash(str_or_hash)
        str_or_hash = JSON.parse(str_or_hash) if str_or_hash.is_a?(String)
        return { 'type' => type } if str_or_hash.nil?
        return str_or_hash.deep_stringify_keys if str_or_hash.is_a?(Hash)

        raise InvalidBlockDataError, str_or_hash
      rescue JSON::ParserError => _e
        raise InvalidBlockDataError, "Invalid JSON: #{str_or_hash}"
      end

      def output_buffer=(v)
        @output_buffer = v
      end

      def output_buffer
        @output_buffer
      end
    end
  end
end
