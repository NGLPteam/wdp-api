# frozen_string_literal: true

module Templates
  module Drops
    class AncestorsDrop < Templates::Drops::AbstractDrop
      # @param [HierarchicalEntity] entity
      def initialize(entity)
        super()

        @entity = entity
      end

      # @raise [Liquid::UndefinedDropMethod]
      def liquid_method_missing(name)
        ancestor = @entity.ancestor_by_name(name)

        return entity_drop_for(ancestor) if ancestor

        super
      end
    end
  end
end
