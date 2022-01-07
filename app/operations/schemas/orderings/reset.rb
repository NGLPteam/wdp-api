# frozen_string_literal: true

module Schemas
  module Orderings
    # Reset an {Ordering} to a base state.
    #
    # When ran, this operation re-enables the ordering, ensures that the ordering's
    # schema version matches its parent entity, and then does one of two things
    # depending on whether or not the ordering is inherited from a {SchemaVersion}:
    #
    # If it's from a schema, it will reset the definition to that of the schema's,
    #
    # @operation
    class Reset
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      prepend TransactionalCall

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def call(ordering)
        persisted = yield reset! ordering

        Success persisted
      end

      private

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def reset!(ordering)
        ordering.disabled_at = nil

        ordering.schema_version = ordering.entity.schema_version

        if ordering.schema_version.has_ordering?(ordering.identifier)
          reset_inherited! ordering
        else
          reset_created! ordering
        end
      end

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def reset_inherited!(ordering)
        inherited_definition = ordering.schema_version.ordering_definition_for ordering.identifier

        ordering.definition = inherited_definition.as_json

        ordering.pristine = true

        ordering.schema_position = ordering.position = inherited_definition.schema_position

        monadic_save ordering
      end

      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def reset_created!(ordering)
        ordering.definition = {
          id: ordering.identifier,
          name: ordering.definition.name,
          order: [{ path: "entity.updated_at", direction: "desc", nulls: "last" }]
        }

        ordering.position = nil

        ordering.pristine = false

        monadic_save ordering
      end
    end
  end
end
