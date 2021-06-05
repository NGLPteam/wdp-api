# frozen_string_literal: true

module Types
  # @see Roles::PermissionGrid
  class PermissionGridType < Types::BaseObject
    description "A grid of permissions specific to a certain scope"

    field :read, Boolean, null: false
    field :create, Boolean, null: false
    field :update, Boolean, null: false
    field :delete, Boolean, null: false
    field :manage_access, Boolean, null: false
  end
end
