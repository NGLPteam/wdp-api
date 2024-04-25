# frozen_string_literal: true

module Schemas
  module Instances
    # @see InitialOrderingSelection
    # @see Mutations::Operations::ClearInitialOrdering
    # @see Schemas::Orderings::CalculateInitial
    class ClearInitialOrdering
      include Dry::Monads[:result, :do]
      include MeruAPI::Deps[calculate_initial: "schemas.orderings.calculate_initial"]

      # @param [HasSchemaDefinition] entity
      # @return [Dry::Monads::Result]
      def call(entity)
        InitialOrderingSelection.for_entity(entity).destroy_all

        yield calculate_initial.(entity:)

        Success()
      end
    end
  end
end
