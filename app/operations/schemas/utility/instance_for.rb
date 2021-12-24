# frozen_string_literal: true

module Schemas
  module Utility
    # A utility service for getting the actual schema instance (read: {Item}, {Collection}) from
    # adjacent models.
    class InstanceFor
      # @param [Entity, EntityLink, HierarchicalEntity] entity
      # @return [Dry::Monads::Success(HasSchemaDefinition)]
      def call(entity)
        case entity
        when ::HasSchemaDefinition
          entity
        when ::Entity
          call entity.hierarchical
        when ::EntityLink
          call entity.target
        else
          raise TypeError, "Cannot get a SchemaInstance from #{entity.inspect}"
        end
      end
    end
  end
end
