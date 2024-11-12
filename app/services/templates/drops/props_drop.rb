# frozen_string_literal: true

module Templates
  module Drops
    class PropsDrop < Templates::Drops::AbstractDrop
      # @param [HierarchicalEntity] entity
      def initialize(entity)
        super()

        @entity = entity

        @prop_drops = props_to_drops(entity.read_properties!)
      end

      # @param [String] name potential property name
      def liquid_method_missing(name)
        @prop_drops.fetch(name) do
          raise Liquid::UndefinedDropMethod, "unknown entity property: #{name}"
        end
      end

      def to_s
        # :nocov:
        raise Liquid::ContextError, "Tried to render `props` directly"
        # :nocov:
      end
    end
  end
end
