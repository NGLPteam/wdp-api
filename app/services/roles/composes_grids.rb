# frozen_string_literal: true

module Roles
  module ComposesGrids
    extend ActiveSupport::Concern

    include ActiveSupport::Configurable

    included do
      include StoreModel::Model

      config.base_scope = nil
      config.permission_grids = {}
    end

    # @param [#to_s]
    # @return [Boolean]
    def [](name)
      attributes[name.to_s]
    end

    # @param [#to_s, nil] scope
    # @return [<String>]
    def calculate_allowed_actions(scope: config.base_scope)
      attributes.reduce([]) do |actions, (name, value)|
        scoped_name = compose_scope(scope, name)

        case value
        when true
          actions.concat([scoped_name])
        when Roles::Grid
          actions.concat(value.calculate_allowed_actions(scope: scoped_name))
        else
          actions
        end
      end
    end

    alias allowed_actions calculate_allowed_actions

    # @return [{ Symbol => Roles::Grid }]
    def permission_grids
      self.class.permission_grid_names.index_with do |grid_name|
        public_send(grid_name)
      end
    end

    # @param [#to_s, nil] scope
    # @return [{ Symbol => { Symbol => Boolean, { Symbol => Boolean } } }]
    def permissions(scope: config.base_scope)
      own_permissions = kind_of?(Roles::Grid) ? to_permissions(scope: scope) : []

      nested_permissions = permission_grids.flat_map do |name, grid|
        grid.to_permissions(scope: compose_scope(scope, name))
      end

      own_permissions + nested_permissions
    end

    private

    # @param [#to_s, nil] scope
    # @param [#to_s] name
    # @return [String]
    def compose_scope(scope, name)
      scope.present? ? "#{scope}.#{name}" : name.to_s
    end

    module ClassMethods
      # @see #build_with
      # @return [Roles::ComposesGrids]
      def allow_everything
        build_with true
      end

      # @param [Boolean, { Symbol => Boolean }] initial_value
      # @return [Roles::ComposesGrids]
      def build_with(initial_value)
        params = build_params_from initial_value

        new params
      end

      # @param [Boolean, { Symbol => Boolean }] initial_value
      # @return [{ Symbol => Boolean }]
      def build_params_from(initial_value)
        permission_grids.each_with_object({}) do |(grid_name, definition), h|
          specific_value = initial_value.kind_of?(Hash) && initial_value[grid_name].kind_of?(Hash) ? initial_value[grid_name] : initial_value

          h[grid_name] = definition[:type].build_params_from(specific_value)
        end
      end

      # @param [#to_sym] name
      # @param [Class] type must implement {Roles::Grid}
      # @param [Boolean, { Symbol => Boolean }] default (@see Roles::Grid::ClassMethods#build_params_for)
      # @return [void]
      def grid(name, type = Roles::PermissionGrid, default: {})
        name = name.to_sym

        type = Roles::Grid::INHERITED[type]

        default_value = type.build_params_from(default)

        attribute name, type.to_type, default: default_value

        define_grid! name, type: type, default: default_value
      end

      def permission_grids
        config.permission_grids
      end

      def permission_grid_names
        config.permission_grids.keys
      end

      def permission_paths
        permission_grids.flat_map do |(name, definition)|
          definition[:type].allow_everything.allowed_actions(scope: name)
        end
      end

      private

      def define_grid!(name, **options)
        config.permission_grids = config.permission_grids.merge(name => options)
      end
    end
  end
end
