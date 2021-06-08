# frozen_string_literal: true

module Types
  class CommunityType < Types::AbstractModel
    implements Types::EntityType

    description "A community of users"

    field :collections, resolver: Resolvers::CollectionResolver

    field :position, Integer, null: true
    field :name, String, null: false
    field :metadata, GraphQL::Types::JSON, null: true
  end
end
