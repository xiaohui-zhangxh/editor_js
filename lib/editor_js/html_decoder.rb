module EditorJS
  class HTMLDecoder
    def decode(text)
      html_decoder.decode(text)
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
