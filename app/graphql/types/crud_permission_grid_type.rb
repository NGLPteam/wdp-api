# frozen_string_literal: true

module Types
  # @see Roles::PermissionGrid
  class CRUDPermissionGridType < Types::BaseObject
    implements Types::PermissionGridType

    description "A grid of permissions for creating, retrieving, updating, and deleting a model"

    field :read, Boolean, null: false
    field :create, Boolean, null: false
    field :update, Boolean, null: false
    field :delete, Boolean, null: false
  end
end
