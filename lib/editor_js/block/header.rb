module EditorJS
  module Block
    # HTML h1, h2, h3, h4, h5, h6 tags
    class Header < Base
      define_schema YAML.safe_load(<<~YAML)
        type: object
        additionalProperties: false
        properties:
          text:
            type: string
          level:
            type: number
            enum: [1,2,3,4,5,6]
          alignment:
            type: string
            enum:
              - align-left
              - align-center
              - align-right
        required:
        - text
        - level
      YAML
    end
  end
end
