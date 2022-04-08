# frozen_string_literal: true

module Types
  # @see Searching::Scope
  class SearchScopeType < Types::BaseObject
    field :origin_type, Types::SearchOriginTypeType, null: false

    field :visibility, Types::EntityVisibilityFilterType, null: false

    field :core_properties, [Types::SearchableCorePropertyType, { null: false }], null: false

    field :available_schema_versions, [Types::SchemaVersionType, { null: false }], null: false do
      description <<~TEXT
      The available schema versions underneath this search scope.
      TEXT
    end

    field :results, resolver: Resolvers::SearchResultResolver

    def core_properties
      ::StaticProperty.searchable_core_properties
    end
  end
end
