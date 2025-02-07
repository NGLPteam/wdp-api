# frozen_string_literal: true

module Types
  # @see Resolvers::SearchResultResolver
  class SearchResultType < Types::BaseObject
    description <<~TEXT
    An entity that's the result of a search.
    TEXT

    field :entity, Types::AnyEntityType, null: false do
      description <<~TEXT
      A reference to the actual entity returned by the search query.
      TEXT
    end

    field :kind, Types::EntityKindType, null: false do
      description <<~TEXT
      The kind of entity returned by the search results.
      TEXT
    end

    field :id, ID, null: false do
      description <<~TEXT
      The encoded ID for the entity itself, not a special ID for the search result record.
      TEXT
    end

    field :schema_version, Types::SchemaVersionType, null: false do
      description <<~TEXT
      The schema version of the returned entity.
      TEXT
    end

    field :slug, Types::SlugType, null: false do
      description <<~TEXT
      The slug for the entity.
      TEXT
    end

    field :title, String, null: false do
      description <<~TEXT
      The title for the entity.
      TEXT
    end

    load_association! :hierarchical, as: :entity
    load_association! :schema_version

    # @return [Promise(String)]
    def id
      entity.then do |ent|
        Promise.resolve(ent.to_encoded_id)
      end
    end

    # @return [String]
    def kind
      object.hierarchical_type
    end

    # @return [String]
    def slug
      object.hierarchical_id
    end
  end
end
