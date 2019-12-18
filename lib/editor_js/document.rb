require 'json'
require 'yaml'

module EditorJs
  class Document
    SCHEMA = YAML.safe_load(<<~YAML)
      type: object
      additionalProperties: false
      properties:
        time:
          type: number
        blocks:
          type: array
          items:
            type: object
        version:
          type: string
    YAML

    def initialize(str_or_hash)
      str_or_hash = JSON.parse(str_or_hash) unless str_or_hash.is_a?(Hash)
      @content = str_or_hash
      @blocks = []
    end

    def valid?
      return @valid if instance_variable_defined?(:@valid)

      @valid = JSON::Validator.validate(SCHEMA, @content)
      return false unless @valid

      blocks = @content['blocks'].map do |blk_data|
        EditorJs::Blocks::Base.load(blk_data)
      end
      @valid = blocks.all?(&:valid?)
      @blocks = blocks if @valid
      @valid
    end

    def render
      return @renderred_html if instance_variable_defined?(:@renderred_html)

      @renderred_html = valid? ? @blocks.map(&:render).join : ''
    end

    def plain
      return @renderred_plain if instance_variable_defined?(:@renderred_plain)

      @renderred_plain = valid? && @blocks.map(&:plain).select do |text|
        text if text.present?
      end.join('. ') || ''
    end

    def output
      return @output if instance_variable_defined?(:@output)

      @output = valid? ? @content.merge('blocks' => @blocks.map(&:output)) : {}
    end
  end
end
