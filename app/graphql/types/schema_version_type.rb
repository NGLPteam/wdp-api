# frozen_string_literal: true

module Types
  class SchemaVersionType < Types::AbstractModel
    description "A specific version of a schema definition"

    implements Types::DescribesSchemaType
    implements HasSchemaPropertiesType

    field :schema_definition, Types::SchemaDefinitionType, null: false

    field :number, String, null: false,
      description: "A semantic version for the schema"

    def slug
      object.system_slug
    end
  end
end
