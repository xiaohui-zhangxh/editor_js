module EditorJS
  module Block
    class Checklist < Base
      define_schema YAML.safe_load(<<~YAML)
        type: object
        additionalProperties: false
        properties:
          items:
            type: array
            items:
              type: object
              additionalProperties: false
              properties:
                text:
                  type: string
                checked:
                  type: boolean
              required:
              - text
      YAML
    end
  end
end
