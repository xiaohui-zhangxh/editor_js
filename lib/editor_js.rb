require 'json'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/output_safety'
require 'action_view'
require 'action_view/helpers'
require 'json-schema'
require 'editor_js/version'
require 'editor_js/blocks/base'
require 'editor_js/blocks/checklist_block'

module EditorJs
  class Error < StandardError; end
end
