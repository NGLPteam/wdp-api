# frozen_string_literal: true

module Harvesting
  module Actions
    # Upsert a single {HarvestEntity}'s associated assets.
    #
    # @see Harveting::Entities::UpsertAssets
    class UpsertEntityAssets < Harvesting::BaseAction
      include WDPAPI::Deps[
        upsert_assets: "harvesting.entities.upsert_assets",
      ]

      runner do
        param :harvest_entity, Harvesting::Types::Entity
      end

      first_argument_provides_middleware!

      defer_ordering_refresh!

      # @param [HarvestEntity] harvest_entity
      # @return [Dry::Monads::Result]
      def perform(harvest_entity)
        upsert_assets.(harvest_entity)
      end
    end
  end
end
