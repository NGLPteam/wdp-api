# frozen_string_literal: true

module Types
  class UserType < Types::AbstractModel
    implements Types::ExposesPermissionsType

    description "A user"

    field :email_verified, Boolean, null: false
    field :email, String, null: true
    field :username, String, null: true
    field :name, String, null: true

    field :global_admin, Boolean, null: false

    def global_admin
      object.has_global_admin_access?
    end
  end
end
