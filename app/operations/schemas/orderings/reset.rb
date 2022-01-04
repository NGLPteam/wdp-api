# frozen_string_literal: true

module Schemas
  module Orderings
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

      def reset!(ordering)
        ordering.disabled_at = nil

        if ordering.schema_version.has_ordering?(ordering.identifier)
          reset_inherited! ordering
        else
          reset_created! ordering
        end
      end

      def reset_inherited!(ordering)
        inherited_definition = ordering.schema_version.ordering_definition_for ordering.identifier

        ordering.definition = inherited_definition.as_json

        ordering.schema_position = ordering.position = inherited_definition.schema_position

        monadic_save ordering
      end

      def reset_created!(ordering)
        ordering.definition = {
          id: ordering.identifier,
          name: ordering.definition.name,
          order: [{ path: "entity.updated_at", direction: "desc", nulls: "last" }]
        }

        ordering.position = nil

        monadic_save ordering
      end
    end
  end
end
