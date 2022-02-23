# frozen_string_literal: true

module Types
  # @see Roles::EntityPermissionGrid
  class EntityPermissionGridType < Types::BaseObject
    implements Types::PermissionGridType
    implements Types::CRUDPermissionGridType

    description "A grid of permissions for various hierarchical entity scopes."

    field :manage_access, Boolean, null: false

    field :assets, Types::AssetPermissionGridType, null: false
  end
end
