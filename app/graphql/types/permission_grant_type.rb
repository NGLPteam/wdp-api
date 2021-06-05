# frozen_string_literal: true

module Types
  class PermissionGrantType < Types::BaseObject
    description "A grant of a specific permission within a specific scope"

    field :scope, Types::PermissionScopeType, null: false
    field :name, Types::PermissionNameType, null: false
    field :allowed, Boolean, null: false
  end
end
