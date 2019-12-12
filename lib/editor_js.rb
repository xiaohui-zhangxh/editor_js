require 'json'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/output_safety'
require 'active_support/core_ext/object/deep_dup'
require 'action_view'
require 'action_view/helpers'
require 'json-schema'
require 'sanitize'
require 'editor_js/version'
require 'editor_js/blocks/base'
require 'editor_js/blocks/checklist_block'
require 'editor_js/blocks/code_block'
require 'editor_js/blocks/delimiter_block'
require 'editor_js/blocks/embed_block'

module EditorJs
  class << self
    # css name prefix of blocks
    def css_name_prefix
      @css_name_prefix ||= 'editor_js--'
    end

    def css_name_prefix=(prefix)
      @css_name_prefix = prefix
    end
  end
end
