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

    field :declaration, String, null: false do
      description <<~TEXT
      The full declaration for this schema, including namespace, identifier, and version (if available).
      TEXT
    end

    field :kind, Types::SchemaKindType, null: false do
      description <<~TEXT
      The kind of entity this schema applies to.
      TEXT
    end

    field :identifier, String, null: false do
      description <<~TEXT
      A unique (per-namespace) value that names the schema within the system.
      TEXT
    end

    field :name, String, null: false do
      description <<~TEXT
      A human-readable name for the schema.
      TEXT
    end

    field :namespace, String, null: false do
      description <<~TEXT
      A unique namespace the schema lives in.
      TEXT
    end
  end
end
