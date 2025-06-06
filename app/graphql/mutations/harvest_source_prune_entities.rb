# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestSourcePruneEntities
  class HarvestSourcePruneEntities < Mutations::BaseMutation
    description <<~TEXT
    Prune harvested entities for a `HarvestSource` record.

    Note: the actual pruning will happen asynchronously in the background, and may take a while.
    TEXT

    field :harvest_source, Types::HarvestSourceType, null: true do
      description <<~TEXT
      The harvest source, if successful.
      TEXT
    end

    argument :harvest_source_id, ID, loads: Types::HarvestSourceType, required: true do
      description <<~TEXT
      The harvest source to update.
      TEXT
    end

    argument :mode, ::Types::HarvestPruneModeType, required: true do
      description <<~TEXT
      Whether to prune `PRISTINE` or **all** harvested entities.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_source_prune_entities"
  end
end
