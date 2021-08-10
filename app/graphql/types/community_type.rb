# frozen_string_literal: true

module Types
  class CommunityType < Types::AbstractModel
    implements Types::EntityType
    implements Types::HasSchemaPropertiesType
    implements Types::AttachableType

    description "A community of users"

    field :collections, resolver: Resolvers::CollectionResolver

    field :position, Integer, null: true
    field :name, String, null: false, deprecation_reason: "Use Community.title"
    field :metadata, GraphQL::Types::JSON, null: true
    field :title, String, null: false
  end
end
