# frozen_string_literal: true

module Harvesting
  module Attempts
    # @see Harvesting::Attempts::EntitiesPruner
    # @see Harvesting::Attempts::PruneEntities
    class PruneEntitiesJob < ApplicationJob
      queue_as :harvest_pruning

      # @return [void]
      def perform(harvest_attempt, **options)
        call_operation!("harvesting.attempts.prune_entities", harvest_attempt, **options)
      end
    end
  end
end
