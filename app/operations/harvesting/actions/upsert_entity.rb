# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a single {HarvestEntity}.
    #
    # @api private
    # @note This is intended for debugging and may not be a part of the final Harvesting API.
    class UpsertEntity < Harvesting::BaseAction
      include WDPAPI::Deps[
        upsert_entity: "harvesting.entities.upsert",
      ]

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Result]
      def call(harvest_entity)
        wrap_middleware.call(harvest_entity) do
          yield upsert_entity.call harvest_entity
        end

        Success nil
      end
    end
  end
end
