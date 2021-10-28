# frozen_string_literal: true

module Roles
  module Grid
    extend ActiveSupport::Concern

    include Roles::ComposesGrids

    included do
      config.permission_names = []

      config_accessor :permission_names, instance_reader: false, instance_writer: false
    end

    INHERITED = AppTypes.Inherits(self)

    # @param [#to_s] scope
    # @return [{ Symbol => String, Boolean }]
    def to_permissions(scope: nil)
      base = scope.present? ? { scope: scope.to_s } : {}

      attributes.flat_map do |name, value|
        case value
        when AppTypes::Bool
          base.merge({ name: name, allowed: value })
        when Roles::Grid
          value.to_permissions scope: compose_scope(scope, name)
        else
          raise TypeError
        end
      end
    end

    module ClassMethods
      def action_names
        permission_names
      end

      # @param [Boolean, { Symbol => Boolean }] initial_value
      # @return [{ Symbol => Boolean }]
      def build_params_from(initial_value)
        build_permission_params_from(initial_value).merge(super)
      end

      # @param [<Symbol>] names
      # @param [Boolean] default
      # @param [{ Symbol => Boolean }] names_with_defaults
      # @return [void]
      def permission(*names, default: false, **names_with_defaults)
        combined = names.flatten.map(&:to_sym).uniq.index_with { default }.merge(names_with_defaults)

        combined.each do |name, default_value|
          next if name.in? permission_names

          attribute name, :boolean, default: default_value

          config.permission_names |= [name]
        end
      end

      # @api private
      def with_scope(parent, scope)
        Class.new(self).tap do |klass|
          klass.scope_parent = parent
          klass.scope_name = scope

          klass.config.permission_grids = klass.permission_grids.each_with_object({}) do |(name, defn), h|
            inherited_type = defn[:type].with_scope(klass, name)

            new_definition = defn.merge(type: inherited_type)

            h[name] = new_definition

            klass.attribute_types[name.to_s].dup.then do |duped_type|
              duped_type.instance_variable_set(:@model_klass, inherited_type)

              klass.attribute_types = klass.attribute_types.merge(name.to_s => duped_type)
            end
          end
        end
      end

      private

      def build_permission_params_from(initial_value)
        case initial_value
        when AppTypes::Bool
          permission_names.index_with { initial_value }
        when Hash
          initial_value.symbolize_keys.slice(*permission_names)
        else
          {}
        end
      end
    end
  end
end
