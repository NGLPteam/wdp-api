# frozen_string_literal: true

module Types
  class UserType < Types::AbstractModel
    implements Types::ExposesPermissionsType

    description "A user"

    field :anonymous, Boolean, null: false, method: :anonymous?
    field :email_verified, Boolean, null: false
    field :email, String, null: true
    field :username, String, null: true
    field :name, String, null: true


    field :communities, resolver: Resolvers::AccessibleCommunityResolver
    field :collections, resolver: Resolvers::AccessibleCollectionResolver
    field :items, resolver: Resolvers::AccessibleItemResolver
    field :global_admin, Boolean, null: false,
      description: "Does this user have access to administer the entire instance?",
      method: :has_global_admin_access?


    field :upload_access, Boolean, null: false,
      description: "Can this user upload anything at all?",
      method: :has_any_upload_access?

  end
end
