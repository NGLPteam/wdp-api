# frozen_string_literal: true

module Types
  class ContextualPermissionType < Types::AbstractModel
    implements Types::ExposesPermissionsType

    description "A contextual permission for a user, role, and entity"

    field :access_control_list, Types::AccessControlListType, null: true do
      description "Derived access control list"
    end

    field :roles, [Types::RoleType, { null: false }], null: false

    field :user, Types::UserType, null: false

    def roles
      object.association(:roles).loaded? ? object.roles : Loaders::AssociationLoader.for(object.class, :roles).load(object)
    end

    def user
      object.association(:user).loaded? ? object.user : Loaders::AssociationLoader.for(object.class, :user).load(object)
    end
  end
end
