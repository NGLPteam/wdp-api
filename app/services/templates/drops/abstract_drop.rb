# frozen_string_literal: true

module Templates
  module Drops
    # @abstract Our abstract override for `Liquid::Drop`
    class AbstractDrop < Liquid::Drop
      include Dry::Core::Memoizable

      private

      def call_operation!(name, ...)
        MeruAPI::Container[name].call(...).value!
      end

      # @param [HierarchicalEntity] entity
      # @return [Templates::Drops::EntityDrop]
      def entity_drop_for(entity)
        entity.to_liquid
      end

      # @see Schemas::Properties::BaseReader#to_liquid
      # @param [HierarchicalEntity] entity
      # @param [<Schemas::Properties::BaseReader>] properties
      # @return [{ String, Symbol => Templates::Drops::GroupPropertyDrop, Templates::Drops::ScalarPropertyDrop }]
      def props_to_drops(properties)
        properties.index_by(&:path).transform_values do |reader|
          reader.to_liquid
        end
      end
    end
  end
end
