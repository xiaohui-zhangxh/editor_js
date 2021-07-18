require 'json'
# require 'active_support/core_ext/hash/keys'
# require 'active_support/core_ext/string/inflections'
# require 'active_support/core_ext/string/output_safety'
# require 'active_support/core_ext/object/deep_dup'
# require 'action_view'
# require 'action_view/helpers'
require 'json-schema'
require 'sanitize'
require 'htmlentities'
require 'redcarpet'
require 'coderay'
require 'editor_js/version'
# require 'editor_js/blocks/base'
# require 'editor_js/blocks/checklist_block'
# require 'editor_js/blocks/code_block'
# require 'editor_js/blocks/delimiter_block'
# require 'editor_js/blocks/embed_block'
# require 'editor_js/blocks/header_block'
# require 'editor_js/blocks/image_block'
# require 'editor_js/blocks/list_block'
# require 'editor_js/blocks/markdown_block'
# require 'editor_js/blocks/paragraph_block'
# require 'editor_js/blocks/qiniu_image_block'
# require 'editor_js/blocks/quote_block'
# require 'editor_js/blocks/warning_block.rb'
# require 'editor_js/blocks/table_block'
# require 'editor_js/blocks/attaches_block'
require 'editor_js/utils'
require 'editor_js/html_decoder'
require 'editor_js/html_sanitizer'
require 'editor_js/text_sanitizer'
require 'editor_js/document2'

require 'editor_js/block/base'
require 'editor_js/block/checklist'
require 'editor_js/block/code'
require 'editor_js/block/header'

require 'editor_js/renderer/block_base'
require 'editor_js/renderer/invalid'
require 'editor_js/renderer/unsupported'
require 'editor_js/renderer/checklist'
require 'editor_js/renderer/code'
require 'editor_js/renderer/header'

module EditorJs
  # class << self
  #   # css name prefix of blocks
  #   def css_name_prefix
  #     @css_name_prefix ||= 'editor_js--'
  #   end

  #   def css_name_prefix=(prefix)
  #     @css_name_prefix = prefix
  #   end
  # end
end
