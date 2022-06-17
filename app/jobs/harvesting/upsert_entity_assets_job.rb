# frozen_string_literal: true

module Harvesting
  # @see Harvesting::Actions::UpsertEntityAssets
  class UpsertEntityAssetsJob < ApplicationJob
    queue_as :asset_fetching

    # @param [HarvestEntity] harvest_entity
    # @return [void]
    def perform(harvest_entity)
      call_operation! "harvesting.actions.upsert_entity_assets", harvest_entity
    end
  end
end
