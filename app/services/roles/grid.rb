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

      private

      def build_permission_params_from(initial_value)
        case initial_value
        when AppTypes::Bool
          permission_names.index_with { true }
        when Hash
          initial_value.symbolize_keys.slice(*permission_names)
        else
          {}
        end
      end
    end
  end
end
