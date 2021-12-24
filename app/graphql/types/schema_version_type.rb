# frozen_string_literal: true

module Types
  # @see SchemaVersion
  class SchemaVersionType < Types::AbstractModel
    description <<~TEXT
    A specific version of a `SchemaDefinition`.
    TEXT

    implements Types::DescribesSchemaType
    implements HasSchemaPropertiesType

    field :schema_definition, Types::SchemaDefinitionType, null: false,
      description: "The shared schema definition for all versions of this namespace and identifier"

    field :number, String, null: false,
      description: "A semantic version for the schema"

    def slug
      object.declaration
    end
  end
end
