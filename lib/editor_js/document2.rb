# frozen_string_literal: true

require 'json'
require 'forwardable'

module EditorJS
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
      required:
      - time
      - blocks
      - version
    YAML

    attr_reader :time, :blocks, :version, :content

    # == Usage
    #   doc = EditorJS::Document.new(editor_js_content,
    #     supported_blocks: {
    #       header: EditorJS::Blocks::Header
    #     })
    #   renderer = EditorJS::Renderer::Document.new(
    #     block_renderers: {
    #       header: EditorJS::Renderer::Header.new,
    #       markdown: EditorJS::Renderer::Markdown.new
    #     },
    #     unknown_block_renderer: EditorJS::Renderer::Unknown.new
    #     invalid_block_renderer: EditorJS::Renderer::Invalid.new
    #   )
    #   renderer.render_html(doc, tag_helper: ActionController::Base.helpers)
    #   renderer.render_text(doc, tag_helper: ActionController::Base.helpers)
    def initialize(json_string_or_hash, supported_blocks: {}, unsupported_block:)
      @content = if json_string_or_hash.is_a?(Hash)
                   Utils.stringify_keys(json_string_or_hash)
                 else
                   JSON.parse(json_string, symbolize_names: true)
                 end
      @supported_blocks = Utils.symbolize_keys(supported_blocks)
      @unsupported_block = unsupported_block

      parse!
    end

    def valid?
      return @valid if instance_variable_defined?(:@valid)

      @valid = JSON::Validator.validate(SCHEMA, content)
    end

    private

    def parse!
      return unless valid?

      @time = content[:time].to_i
      @version = content[:version]
      @blocks = content[:blocks].map do |block_hash|
        parse_block(block_hash)
      end
    end

    def parse_block(block_hash)
      block_klass = @supported_blocks[block_hash[:type]] || @unsupported_block
      block_klass.new(block_hash)
    end
  end
end
