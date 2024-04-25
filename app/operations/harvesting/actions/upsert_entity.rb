# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a single {HarvestEntity}.
    #
    # @api private
    # @note This is intended for debugging and may not be a part of the final Harvesting API.
    class UpsertEntity < Harvesting::BaseAction
      include MeruAPI::Deps[
        upsert_entity: "harvesting.entities.upsert",
      ]

      runner do
        param :harvest_entity, Harvesting::Types::Entity
      end

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Result]
      def perform(harvest_entity)
        upsert_entity.(harvest_entity)
      end
    end
  end
end
