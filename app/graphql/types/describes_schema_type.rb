# frozen_string_literal: true

module Types
  # @see HierarchicalSchemaRank
  # @see HierarchicalSchemaVersionRank
  # @see SchemaDefinition
  # @see SchemaVersion
  module DescribesSchemaType
    include Types::BaseInterface

    description <<~TEXT
    The most basic shared properties for a single schema, whether a definition,
    a version, or an aggregate based on the former types.
    TEXT

    field :kind, Types::SchemaKindType, null: false,
      description: "The kind of entity this schema applies to"

    field :identifier, String, null: false,
      description: "A unique (per-namespace) value that names the schema within the system."

    field :name, String, null: false,
      description: "A human-readable name for the schema"

    field :namespace, String, null: false,
      description: "A unique namespace the schema lives in"
  end
end
