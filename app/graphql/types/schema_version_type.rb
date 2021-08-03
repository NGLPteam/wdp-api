# frozen_string_literal: true

module Types
  class SchemaVersionType < Types::AbstractModel
    description "A specific version of a schema definition"

    implements HasSchemaPropertiesType

    field :schema_definition, Types::SchemaDefinitionType, null: false

    field :kind, Types::SchemaKindType, null: false
    field :identifier, String, null: false
    field :name, String, null: false
    field :namespace, String, null: false
    field :number, String, null: false

    def slug
      object.system_slug
    end
  end
end
