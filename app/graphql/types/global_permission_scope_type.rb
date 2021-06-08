# frozen_string_literal: true

module Types
  class GlobalPermissionScopeType < Types::BaseEnum
    value "communities"
    value "settings"
    value "users"
  end
end
