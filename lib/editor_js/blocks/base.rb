module EditorJs
  module Blocks
    class Base
      InvalidBlockDataError = Class.new(StandardError)
      InvalidBlockTypeError = Class.new(StandardError)
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
        self.class.type
      end

      def data
        @content['data']
      end

      def decode_html(string)
        html_decoder.decode(string)
      end

      def css_name(name = nil)
        "#{css_prefix}#{name}"
      end

      def output
        @content
      end

      def self.type
        @type ||= self.to_s.underscore.split('/').last.gsub('_block', '')
      end

      def self.inherited(parent)
        @registry ||= {}
        @registry[parent.type] = parent
        super
      end

      def self.load(block_data)
        block_data = JSON.parse(block_data) unless block_data.is_a?(Hash)
        klass = @registry[block_data['type']]
        raise InvalidBlockTypeError, block_data['type'] if klass.nil?

        klass.new(block_data)
      end

      private

      def cast_block_data_to_hash(block_data)
        raise InvalidBlockDataError, block_data unless block_data.is_a?(Hash)

        block_data = block_data.deep_stringify_keys
        raise InvalidBlockDataError, "block type <#{block_data['type']}> doesn't match <#{type}>" unless block_data['type'] == type

        block_data
      rescue JSON::ParserError => _e
        raise InvalidBlockDataError, "Invalid JSON: #{block_data}"
      end

      def css_prefix
        @css_prefix ||= "#{EditorJs.css_name_prefix}#{type}"
      end

      def html_decoder
        @html_decoder ||= begin
          with_customized_html_mappings do
            HTMLEntities::Decoder.new('expanded')
          end
        end
      end

      def with_customized_html_mappings
        original_mappings = HTMLEntities::MAPPINGS['expanded']
        customized_mappings = original_mappings.dup
        customized_mappings['nbsp'] = 32
        HTMLEntities::MAPPINGS['expanded'] = customized_mappings
        yield
      ensure
        HTMLEntities::MAPPINGS['expanded'] = original_mappings
      end
    end
  end
end
