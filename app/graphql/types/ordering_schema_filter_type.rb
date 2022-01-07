# frozen_string_literal: true

module Types
  # A GraphQL type for {Schemas::Associations::OrderingFilter}.
  class OrderingSchemaFilterType < Types::BaseObject
    description "This defines a specific schema that an ordering can filter its entries by"

    field :namespace, String, null: false do
      description <<~TEXT
      The namespace the schema occupies.
      TEXT
    end

    field :identifier, String, null: false do
      description <<~TEXT
      The identifier within the namespace for the schema.
      TEXT
    end

    field :version, Types::VersionRequirementType, null: true do
      description <<~TEXT
      An optional version requirement for the associated schema.
      TEXT
    end
  end
end
