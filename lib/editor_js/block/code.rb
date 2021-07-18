module EditorJS
  module Block
    class Code < Base
      define_schema YAML.safe_load(<<~YAML)
        type: object
        additionalProperties: false
        properties:
          code:
            type: string
        required:
        - code
      YAML
    end
  end
end
