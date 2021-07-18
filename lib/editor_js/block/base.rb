module EditorJS
  module Block
    # = Base class of Block
    # == Usage
    #
    #   class EditorJS::Block::Header < EditorJS::Block::Base
    #     define_schema YAML.safe_load(<<~YAML)
    #       type: object
    #       additionalProperties: false
    #       properties:
    #         text:
    #           type: string
    #         level:
    #           type: number
    #           enum: [1,2,3,4,5,6]
    #         alignment:
    #           type: string
    #           enum:
    #             - align-left
    #             - align-center
    #             - align-right
    #       required:
    #       - text
    #       - level
    #     YAML
    #   end
    #
    class Base
      InvalidBlockTypeError = Class.new(StandardError)

      class << self
        attr_reader :schema

        def define_schema(json_schema)
          @schema = json_schema
        end

        def define_type(type)
          @type = type.to_sym
        end

        def type
          @type ||= EditorJS::Utils.underscore(to_s.split('::').last).to_sym
        end
      end

      def initialize(content)
        @content = content
        raise InvalidBlockTypeError if type != self.class.type
      end

      def valid?
        JSON::Validator.validate(self.class.schema, data)
      end

      def type
        EditorJS::Utils.underscore(@content[:type])&.to_sym
      end

      def data
        @content[:data]
      end
    end
  end
end
