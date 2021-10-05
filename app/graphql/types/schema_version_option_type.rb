# frozen_string_literal: true

module Types
  class SchemaVersionOptionType < Types::BaseObject
    field :label, String, null: false,
      description: "The label to display in a select box"
    field :value, String, null: false,
      description: "The value to use in a select box"

    field :kind, Types::SchemaKindType, null: false
    field :identifier, String, null: false
    field :name, String, null: false
    field :namespace, String, null: false

    field :schema_definition, Types::SchemaDefinitionType, null: false
    field :schema_version, Types::SchemaVersionType, null: false

    def schema_version
      object
    end

    def value
      object.system_slug
    end
  end
end
