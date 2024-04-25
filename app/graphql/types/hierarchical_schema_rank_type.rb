# frozen_string_literal: true

module Types
  class HierarchicalSchemaRankType < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    implements Types::DescribesSchemaType

    global_id_field :id

    description <<~TEXT
    A ranking of a schema from a certain point in the hierarchy. This can be used to generate
    navigation or calculate statistics about what various entities contain.
    TEXT

    field :count, Integer, null: false, method: :schema_count,
      description: "The number of entities that implement this schema from this point in the hierarchy."

    field :rank, Integer, null: false, method: :schema_rank,
      description: "The rank of this schema at this point in the hierarchy, based on the statistical mode of its depth relative to the parent."

    field :distinct_version_count, Integer, null: false,
      description: "A count of distinct versions of this specific schema type from this point of the hierarchy."

    field :schema_definition, Types::SchemaDefinitionType, null: false,
      description: "A reference to the discrete schema definition"

    field :slug, String, null: false,
      description: "A fully-qualified unique value that can be used to refer to this schema within the system",
      method: :schema_slug

    field :version_ranks, [Types::HierarchicalSchemaVersionRankType, { null: false }], null: false,
      description: "A reference to the schema versions from this ranking"

    def schema_definition
      Support::Loaders::AssociationLoader.for(object.class, :schema_definition).load(object)
    end

    def version_ranks
      Support::Loaders::AssociationLoader.for(object.class, :hierarchical_schema_version_ranks).load(object)
    end
  end
end
