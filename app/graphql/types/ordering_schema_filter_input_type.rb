# frozen_string_literal: true

module Types
  # A GraphQL input type for {Schemas::Associations::OrderingFilter}.
  class OrderingSchemaFilterInputType < Types::BaseInputObject
    include AutoHash

    description "This defines a specific schema that an ordering can filter its entries by"

    argument :namespace, String, required: true, attribute: true do
      description <<~TEXT
      The namespace the schema occupies.
      TEXT
    end

    argument :identifier, String, required: true, attribute: true do
      description <<~TEXT
      The identifier within the namespace for the schema.
      TEXT
    end

    argument :version, Types::VersionRequirementType, required: false, attribute: true do
      description <<~TEXT
      An optional version requirement for this ordering. It supports
      Ruby's version declaration syntax, so you can provide a value
      like `">= 1.2"` to match against semantically-versioned schemas.
      TEXT
    end
  end
end
