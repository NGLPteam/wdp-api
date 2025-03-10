# frozen_string_literal: true

module Harvesting
  module Entities
    # @see Harvesting::Entities::UpsertAssets
    # @see Harvesting::Entities::AssetsUpserter
    class UpsertAssetsJob < ApplicationJob
      queue_as :asset_fetching

      # @param [HarvestEntity] harvest_entity
      # @return [void]
      def perform(harvest_entity)
        call_operation! "harvesting.entities.upsert_assets", harvest_entity
      end
    end
  end
end
