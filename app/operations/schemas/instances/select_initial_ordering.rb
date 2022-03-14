# frozen_string_literal: true

module Schemas
  module Instances
    # @see InitialOrderingSelection
    # @see Mutations::Operations::SelectInitialOrdering
    # @see Schemas::Orderings::CalculateInitial
    class SelectInitialOrdering
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[calculate_initial: "schemas.orderings.calculate_initial"]

      UNIQUE_KEYS = %i[entity_type entity_id].freeze

      # @param [HasSchemaDefinition] entity
      # @param [Ordering] ordering
      # @return [Dry::Monads::Result]
      def call(entity, ordering)
        return Failure[:must_be_entity_ordering] unless ordering.entity == entity

        attributes = {
          entity_type: entity.entity_type,
          entity_id: entity.id,
          ordering_id: ordering.id,
        }

        InitialOrderingSelection.upsert attributes, unique_by: UNIQUE_KEYS, returning: nil

        yield calculate_initial.(entity: entity)

        Success()
      end
    end
  end
end
