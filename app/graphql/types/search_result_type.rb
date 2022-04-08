# frozen_string_literal: true

module Types
  # @see Resolvers::SearchResultResolver
  class SearchResultType < Types::BaseObject
    description <<~TEXT
    An entity that's the result of a search.
    TEXT

    field :entity, Types::AnyEntityType, null: false

    field :kind, Types::EntityKindType, null: false

    field :schema_version, Types::SchemaVersionType, null: false

    field :slug, Types::SlugType, null: false

    field :title, String, null: false

    # @return [HierarchicalEntity]
    def entity
      Loaders::AssociationLoader.for(object.class, :hierarchical).load(object)
    end

    # @return [String]
    def kind
      objet.hierarchical_kind
    end

    # @return [SchemaVersion]
    def schema_version
      Loaders::AssociationLoader.for(object.class, :schema_version).load(object)
    end

    # @return [String]
    def slug
      object.hierarchical_id
    end
  end
end
