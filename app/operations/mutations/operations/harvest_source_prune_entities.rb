# frozen_string_literal: true

module Mutations
  module Operations
    # @see Mutations::HarvestSourcePruneEntities
    class HarvestSourcePruneEntities
      include MutationOperations::Base

      authorizes! :harvest_source, with: :prune_entities?

      use_contract! :harvest_source_prune_entities

      # @param [HarvestSource] harvest_source
      # @param [Harvesting::Types::PruneMode] mode
      # @return [void]
      def call(harvest_source:, mode:, **)
        Harvesting::Sources::PruneEntitiesJob.perform_later(harvest_source, mode:)

        attach! :harvest_source, harvest_source
      end
    end
  end
end
