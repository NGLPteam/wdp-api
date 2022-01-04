# frozen_string_literal: true

module Schemas
  module Instances
    class PopulateOrderings
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      prepend TransactionalCall

      # @param [HierarchicalEntity] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        entity.schema_version.configuration.orderings.each do |definition|
          yield populate_definition! entity, definition
        end

        Success nil
      end

      private

      # @param [HierarchicalEntity] entity
      # @param [Schemas::Ordering::Definition] definition
      # @return [Dry::Monads::Result]
      def populate_definition!(entity, definition)
        ordering = Ordering.by_entity(entity).by_identifier(definition.id).first_or_initialize do |new_record|
          new_record.schema_version = entity.schema_version
          new_record.definition = definition
          new_record.schema_position = definition.schema_position
          new_record.position = definition.schema_position
        end

        return Success(nil) if ordering.persisted?

        monadic_save ordering
      end
    end
  end
end
