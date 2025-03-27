# frozen_string_literal: true

module Roles
  class EntityPermissionGrid < PermissionGrid
    permission :manage_access

    grid :assets, default: false
  end
end
