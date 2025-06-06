# frozen_string_literal: true

module Harvesting
  module Sources
    # @see Harvesting::Sources::EntitiesPruner
    # @see Harvesting::Sources::PruneEntities
    class PruneEntitiesJob < ApplicationJob
      queue_as :harvest_pruning

      # @return [void]
      def perform(harvest_source, **options)
        call_operation!("harvesting.sources.prune_entities", harvest_source, **options)
      end
    end
  end
end
