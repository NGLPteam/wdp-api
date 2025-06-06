# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestAttemptPruneEntities
    class HarvestAttemptPruneEntities
      include MutationOperations::Base

      authorizes! :harvest_attempt, with: :prune_entities?

      use_contract! :harvest_attempt_prune_entities

      # @param [HarvestAttempt] harvest_attempt
      # @param [Harvesting::Types::PruneMode] mode
      # @return [void]
      def call(harvest_attempt:, mode:, **)
        Harvesting::Attempts::PruneEntitiesJob.perform_later(harvest_attempt, mode:)

        attach! :harvest_attempt, harvest_attempt
      end
    end
  end
end
