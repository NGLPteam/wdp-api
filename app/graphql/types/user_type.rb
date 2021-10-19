# frozen_string_literal: true

module Types
  class UserType < Types::AbstractModel
    implements Types::AccessGrantSubjectType
    implements Types::ExposesPermissionsType

    description "A known or anonymous user in the system. Registration and management is primarily handled through the WDP Keycloak instance."

    field :anonymous, Boolean, null: false, method: :anonymous?,
      description: "Is this an anonymous / unauthenticated user?"

    field :email_verified, Boolean, null: false,
      description: "Has this user's email been verified to work through Keycloak?"

    field :email, String, null: true,
      description: "A user's email. Depending on the upstream provider, this may not be set."
    field :username, String, null: true,
      description: "A unique username for the user. Depending on the upstream provider, this may not be set."
    field :name, String, null: true,
      description: "The user's full provided name. Depending on the upstream provider, this may not be set."

    field :given_name, String, null: true,
      description: "The user's given (first) name. Depending on the upstream provider, this may not be set."

    field :family_name, String, null: true,
      description: "The user's family (last) name. Depending on the upstream provider, this may not be set."

    field :avatar, Types::AssetPreviewType, null: true do
      description "A user's avatar"
    end

    field :global_admin, Boolean, null: false,
      description: "Does this user have access to administer the entire instance?",
      method: :has_global_admin_access?

    field :communities, resolver: Resolvers::AccessibleCommunityResolver,
      description: "Query the communities this user has access to"
    field :collections, resolver: Resolvers::AccessibleCollectionResolver,
      description: "Query the collections this user has access to"
    field :items, resolver: Resolvers::AccessibleItemResolver,
      description: "Query the items this user has access to"

    field :upload_access, Boolean, null: false,
      description: "Can this user upload anything at all?",
      method: :has_any_upload_access?

    field :upload_token, String, null: true,
      description: "If a user has any upload access, this token will allow them to do so."

    field :access_grants, resolver: Resolvers::AccessGrants::UserResolver,
      description: "All access grants for this user"

    field :community_access_grants, resolver: Resolvers::AccessGrants::UserCommunityResolver,
      description: "All access grants for this user on a community"

    field :collection_access_grants, resolver: Resolvers::AccessGrants::UserCollectionResolver,
      description: "All access grants for this user on a collection"

    field :item_access_grants, resolver: Resolvers::AccessGrants::UserItemResolver,
      description: "All access grants for this user on an item"

    def slug
      object.keycloak_id
    end
  end
end
