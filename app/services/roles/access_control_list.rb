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
          actions.concat([name])
        when Roles::PermissionGrid
          actions.concat(value.calculate_allowed_actions(prefix: name))
        else
          actions
        end
      end
    end

    def permission_grids
      self.class.permission_grids.index_with do |grid_name|
        public_send(grid_name)
      end
    end

    def permissions
      permission_grids.flat_map do |scope, grid|
        grid.to_permissions(scope: scope)
      end
    end

    class << self
      def permission_grids
        @permission_grids ||= attribute_types.each_with_object([]) do |(name, attribute), list|
          model_klass = attribute.instance_variable_get(:@model_klass)

          next unless model_klass == Roles::PermissionGrid

          list << name.to_sym
        end
      end
    end
  end
end
