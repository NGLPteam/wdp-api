# frozen_string_literal: true

module Mutations
  class AlterSchemaVersion < Mutations::BaseMutation
    description "Change a schema version for an entity."

    field :entity, Types::AnyEntityType, null: true
    field :community, Types::CommunityType, null: true
    field :collection, Types::CollectionType, null: true
    field :item, Types::ItemType, null: true

    field :schema_errors, [Types::SchemaValueErrorType, { null: false } ], null: false

    argument :entity_id, ID, loads: Types::AnyEntityType, description: "The entity that owns the attachment", required: true

    argument :schema_version_slug, String, required: true, transient: true, attribute: true do
      description "The slug for the new schema to apply"
    end

    argument :property_values, GraphQL::Types::JSON, required: true do
      description <<~TEXT
      An arbitrary set of property values. Owing to the dynamic nature, they do not have a specific GraphQL input type
      associated with them. Validation will be performed within the application and returned as errors if not valid.
      TEXT
    end

    argument :strategy, Types::PropertyApplicationStrategyType, required: false, default_value: :apply do
      description <<~TEXT
      This argument dictates how the mutation should handle received property values.
      If set to `SKIP`, it will alter the schema version without setting any new properties.
      TEXT
    end

    performs_operation! "mutations.operations.alter_schema_version"
  end
end
