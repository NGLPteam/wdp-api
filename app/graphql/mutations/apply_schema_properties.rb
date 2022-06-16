# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::ApplySchemaProperties
  # @see Schemas::Instances::Apply
  class ApplySchemaProperties < Mutations::BaseMutation
    field :entity, Types::AnyEntityType, null: true
    field :community, Types::CommunityType, null: true
    field :collection, Types::CollectionType, null: true
    field :item, Types::ItemType, null: true

    field :schema_errors, [Types::SchemaValueErrorType, { null: false } ], null: false

    argument :entity_id, ID, loads: Types::AnyEntityType, description: "The entity that owns the attachment", required: true
    argument :property_values, GraphQL::Types::JSON, required: true do
      description <<~TEXT
      An arbitrary set of property values. Owing to the dynamic nature, they do not have a specific GraphQL input type
      associated with them. Validation will be performed within the application and returned as errors if not valid.
      TEXT
    end

    performs_operation! "mutations.operations.apply_schema_properties"
  end
end
