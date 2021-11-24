# frozen_string_literal: true

module Types
  class HierarchicalSchemaVersionRankType < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    implements Types::DescribesSchemaType

    global_id_field :id

    description <<~TEXT
    A ranking of a schema version from a certain point in the hierarchy. This can be used to generate
    navigation or calculate statistics about what versions of a schema various entities contain.
    TEXT

    field :count, Integer, null: false, method: :schema_count,
      description: "The number of entities that implement this schema from this point in the hierarchy."

    field :rank, Integer, null: false, method: :schema_rank,
      description: "The rank of this schema at this point in the hierarchy, based on the statistical mode of its depth relative to the parent."

    field :schema_definition, Types::SchemaDefinitionType, null: false,
      description: "A reference to the discrete schema definition"

    field :schema_version, Types::SchemaVersionType, null: false,
      description: "A reference to the discrete schema version"

    field :version_number, String, null: false,
      description: "A semantic version associated with the schema"

    field :slug, String, null: false,
      description: "A fully-qualified unique value that can be used to refer to this schema within the system",
      method: :schema_slug
  end
end
