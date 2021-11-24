# frozen_string_literal: true

module Types
  module DescribesSchemaType
    include Types::BaseInterface

    description <<~TEXT
    An interface used to describe a schema definition, whether for a discrete
    type or in some aggregate.
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
