# frozen_string_literal: true

module Roles
  class GlobalAccessControlList
    include Roles::ComposesGrids

    grid :communities, default: false
    grid :users, default: false
    grid :settings, Roles::SettingsGrid, default: false
  end
end
