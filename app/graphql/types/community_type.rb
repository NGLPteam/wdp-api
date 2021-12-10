# frozen_string_literal: true

module Types
  class CommunityType < Types::AbstractModel
    implements Types::AccessibleType
    implements Types::EntityType
    implements Types::HasSchemaPropertiesType
    implements Types::AttachableType
    implements Types::SchemaInstanceType

    description "A community of users"

    field :collections, resolver: Resolvers::CollectionResolver

    field :position, Integer, null: true
    field :name, String, null: false, deprecation_reason: "Use Community.title"
    field :metadata, GraphQL::Types::JSON, null: true
    field :title, String, null: false

    field :first_collection, resolver: Resolvers::SingleSubcollectionResolver
    field :first_item, resolver: Resolvers::SingleSubitemResolver

    field :access_grants, resolver: Resolvers::AccessGrants::CommunityResolver

    field :user_access_grants, resolver: Resolvers::AccessGrants::UserCommunityResolver,
      description: "Access grants for specific users"

    field :user_group_access_grants, resolver: Resolvers::AccessGrants::UserGroupCommunityResolver,
      description: "Not presently used"
  end
end
