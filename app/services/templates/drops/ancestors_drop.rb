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
        ancestor = @entity.ancestor_by_name(name, enforce_known: true)

        return entity_drop_for(ancestor) if ancestor
      rescue Entities::UnknownAncestor => e
        # :nocov:
        raise Liquid::UndefinedDropMethod, e.message
        # :nocov:
      end

      def to_s
        # :nocov:
        raise Liquid::ContextError, "Tried to render `ancestors` directly"
        # :nocov:
      end
    end
  end
end
