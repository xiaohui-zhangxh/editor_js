# frozen_string_literal: true

module EditorJS
  module Utils
    module_function

    # copy from activesupport/lib/active_support/inflector/methods.rb
    def underscore(camel_cased_word)
      return nil if camel_cased_word.nil?

      word = camel_cased_word.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word
    end

    def possible_html_safe(string)
      string.respond_to?(:html_safe) ? string.html_safe : string
    end

    def stringify_keys(hash)
      hash.each_with_object({}) do |key_value, new_hash|
        key, value = key_value
        value = stringify_keys(value) if value.is_a?(Hash)
        new_hash[key.to_s] = value
      end
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |key_value, new_hash|
        key, value = key_value
        value = symbolize_keys(value) if value.is_a?(Hash)
        new_hash[key.to_sym] = value
      end
    end

    def blank?(text)
      text.nil? || text.strip.empty?
    end
  end
end
