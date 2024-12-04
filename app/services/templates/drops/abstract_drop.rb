# frozen_string_literal: true

module Templates
  module Drops
    # @abstract Our abstract override for `Liquid::Drop`
    class AbstractDrop < Liquid::Drop
      extend Dry::Core::ClassAttributes

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
    end
  end
end
