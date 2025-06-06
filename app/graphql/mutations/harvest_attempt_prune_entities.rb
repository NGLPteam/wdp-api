# frozen_string_literal: true

module Mutations
  # @see Mutations::Operations::HarvestAttemptPruneEntities
  class HarvestAttemptPruneEntities < Mutations::BaseMutation
    description <<~TEXT
    Prune harvested entities for a `HarvestAttempt` record.

    Note: the actual pruning will happen asynchronously in the background, and may take a while.
    TEXT

    field :harvest_attempt, Types::HarvestAttemptType, null: true do
      description <<~TEXT
      The harvest attempt, if successful.
      TEXT
    end

    argument :harvest_attempt_id, ID, loads: Types::HarvestAttemptType, required: true do
      description <<~TEXT
      The harvest attempt to update.
      TEXT
    end

    argument :mode, ::Types::HarvestPruneModeType, required: true do
      description <<~TEXT
      Whether to prune `PRISTINE` or **all** harvested entities.
      TEXT
    end

    performs_operation! "mutations.operations.harvest_attempt_prune_entities"
  end
end
