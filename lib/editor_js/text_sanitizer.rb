require 'sanitize'
module EditorJS
  class TextSanitizer
    attr_reader :options
    def initialize(**options)
      @options = options
    end

    def sanitize(text)
      Sanitize.fragment(text, **options)
    end
  end
end
