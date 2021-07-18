# frozen_string_literal: true

module EditorJS
  module Renderer
    class Document
      def initialize(block_renderers:,
                     unknown_block_renderer:,
                     invalid_block_renderer:)
        @block_renderers = block_renderers
        @unknown_block_renderer = unknown_block_renderer
        @invalid_block_renderer = invalid_block_renderer
      end

      def render_html(document, tag_helper:)
        rendered_blocks = document.blocks.map do |block|
          renderer = block_renderer(block)
          renderer.render_html(block, tag_helper: tag_helper)
        end
        Utils.possible_html_safe(rendered_blocks.join("\n"))
      end

      def render_text(document)
        rendered_blocks = document.blocks.map do |block|
          renderer = block_renderer(block)
          renderer.render_text(block)
        end
        rendered_blocks.join("\n")
      end

      private

      def block_renderer(block)
        if block.valid?
          @block_renderer[block.type] || @unknown_block_renderer
        else
          @invalid_block_render
        end
      end
    end
  end
end
