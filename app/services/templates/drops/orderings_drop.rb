# frozen_string_literal: true

module Templates
  module Drops
    class OrderingsDrop < Templates::Drops::AbstractDrop
      # @param [HierarchicalEntity] entity
      def initialize(entity)
        @entity = entity
      end

      # @param [#to_s] name
      def liquid_method_missing(name)
        fetch_ordering_drop(name)
      rescue Entities::UnknownProperty => e
        raise Liquid::UndefinedDropMethod, e.message
      end

      def to_s
        # :nocov:
        raise Liquid::ContextError, "Tried to render orderings in scalar context"
        # :nocov:
      end

      private

      # @return [HierarchicalEntity]
      attr_reader :entity

      # @see HierarchicalEntity#ordering!
      def fetch_ordering_drop(ordering_identifier)
        ordering = @entity.ordering!(ordering_identifier)
      rescue ActiveRecord::RecordNotFound
        raise Entities::UnknownOrdering.new(ordering_identifier:, entity:)
      else
        ordering.to_liquid
      end
    end
  end
end
