# frozen_string_literal: true

module Types
  class PermissionScopeType < Types::BaseEnum
    value "self"
    value "collections"
    value "items"
    value "assets"

    value "communities"
    value "settings"
    value "users"
  end
end
