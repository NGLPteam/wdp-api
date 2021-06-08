# frozen_string_literal: true

module Roles
  class GlobalAccessControlList
    include Roles::ComposesGrids

    grid :communities, default: true
    grid :users, default: true
    grid :settings, Roles::SettingsGrid, default: true
  end
end
