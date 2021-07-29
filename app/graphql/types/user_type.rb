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

    field :global_admin, Boolean, null: false

    field :communities, resolver: Resolvers::AccessibleCommunityResolver
    field :collections, resolver: Resolvers::AccessibleCollectionResolver
    field :items, resolver: Resolvers::AccessibleItemResolver

    def global_admin
      object.has_global_admin_access?
    end
  end
end
