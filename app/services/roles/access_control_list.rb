# frozen_string_literal: true

module Roles
  class AccessControlList
    include Roles::ComposesGrids

    grid :self, EntityPermissionGrid
    grid :collections, EntityPermissionGrid
    grid :items, EntityPermissionGrid
  end
end
