# frozen_string_literal: true

module Types
  # @see Resolvers::SearchResultResolver
  class SearchResultType < Types::BaseObject
    description <<~TEXT
    An entity that's the result of a search.
    TEXT

    field :entity, Types::AnyEntityType, null: false

    field :kind, Types::EntityKindType, null: false

    field :id, ID, null: false

    field :schema_version, Types::SchemaVersionType, null: false

    field :slug, Types::SlugType, null: false

    field :title, String, null: false

    # @return [HierarchicalEntity]
    def entity
      Support::Loaders::AssociationLoader.for(object.class, :hierarchical).load(object)
    end

    # @return [String]
    def id
      entity.then do |ent|
        Promise.resolve(ent.to_encoded_id)
      end
    end

    # @return [String]
    def kind
      object.hierarchical_type
    end

    # @return [SchemaVersion]
    def schema_version
      Support::Loaders::AssociationLoader.for(object.class, :schema_version).load(object)
    end

    # @return [String]
    def slug
      object.hierarchical_id
    end
  end
end
