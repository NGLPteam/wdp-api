# frozen_string_literal: true

module Roles
  class GlobalAccessControlList
    include Roles::ComposesGrids

    grid :communities, EntityPermissionGrid, default: false
    grid :contributors, default: false
    grid :users, default: false
    grid :settings, Roles::SettingsGrid, default: false
  end
end
