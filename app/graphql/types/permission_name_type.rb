# frozen_string_literal: true

module Types
  class PermissionNameType < Types::BaseEnum
    description "A permission that can be granted within the system"

    value "read"
    value "create"
    value "update"
    value "delete"
    value "manage_access"
  end
end
