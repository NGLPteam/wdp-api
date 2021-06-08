# frozen_string_literal: true

module Types
  # @see Roles::EntityPermissionGrid
  class EntityPermissionGridType < Types::BaseObject
    implements Types::PermissionGridType

    description "A mapping of permissions for various hierarchical entity scopes"

    field :read, Boolean, null: false
    field :create, Boolean, null: false
    field :update, Boolean, null: false
    field :delete, Boolean, null: false
    field :manage_access, Boolean, null: false

    field :assets, Types::CRUDPermissionGridType, null: false
  end
end
