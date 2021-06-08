# frozen_string_literal: true

module Roles
  # @todo Actually stitch up the assets
  class EntityPermissionGrid < PermissionGrid
    permission :manage_access

    grid :assets, default: true
  end
end
