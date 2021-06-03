# frozen_string_literal: true

module Roles
  class AccessControlList
    include StoreModel::Model

    attribute :self, Roles::PermissionGrid.to_type, default: {}
    attribute :collections, Roles::PermissionGrid.to_type, default: {}
    attribute :items, Roles::PermissionGrid.to_type, default: {}

    def calculate_allowed_actions
      attributes.reduce([]) do |actions, (name, value)|
        case value
        when true
          name
        when Roles::PermissionGrid
          actions.concat(value.calculate_allowed_actions(prefix: name))
        else
          actions
        end
      end
    end
  end
end
