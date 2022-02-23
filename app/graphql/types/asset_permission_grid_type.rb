# frozen_string_literal: true

module Types
  # @see Roles::PermissionGrid
  class AssetPermissionGridType < Types::BaseObject
    implements Types::PermissionGridType
    implements Types::CRUDPermissionGridType

    description "A grid of permissions for creating, retrieving, updating, and deleting an `Asset`"
  end
end
