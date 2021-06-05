# frozen_string_literal: true

module Types
  class PermissionScopeType < Types::BaseEnum
    value "self"
    value "collections"
    value "items"
  end
end
