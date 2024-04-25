# frozen_string_literal: true

module Types
  class ContextualPermissionType < Types::AbstractModel
    implements Types::ExposesPermissionsType

    description "A contextual permission for a user, role, and entity"

    field :access_control_list, Types::AccessControlListType, null: true do
      description "Derived access control list"
    end

    field :access_grants, [Types::AnyUserAccessGrantType, { null: false }], null: false,
      description: "The access grants that correspond to this contextual permission"

    field :roles, [Types::RoleType, { null: false }], null: false,
      description: "The roles that correspond to this contextual permission"

    field :user, Types::UserType, null: false

    def access_grants
      object.association(:access_grants).loaded? ? object.access_grants : Support::Loaders::AssociationLoader.for(object.class, :access_grants).load(object)
    end

    def roles
      object.association(:roles).loaded? ? object.roles : Support::Loaders::AssociationLoader.for(object.class, :roles).load(object)
    end

    def user
      object.association(:user).loaded? ? object.user : Support::Loaders::AssociationLoader.for(object.class, :user).load(object)
    end
  end
end
