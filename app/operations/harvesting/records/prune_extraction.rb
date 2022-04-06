# frozen_string_literal: true

module Harvesting
  module Records
    # Prune multiple records during {HarvestRecord record} extraction.
    #
    # @api private
    # @see Harvesting::Records::PruneEntities
    # @see Harvesting::Records::PruneContributions
    # @see Harvesting::Records::PruneContributors
    class PruneExtraction
      include WDPAPI::Deps[
        prune_entities: "harvesting.records.prune_entities",
        prune_contributions: "harvesting.records.prune_contributions",
        prune_contributors: "harvesting.records.prune_contributors",
      ]

      # @param [HarvestRecord] harvest_record
      # @yield The actual extraction process should be provided in a block
      # @yieldreturn [Dry::Monads::Result]
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        prune_contributors.call(harvest_record) do
          prune_contributions.call(harvest_record) do
            prune_entities.call(harvest_record) do
              yield
            end
          end
        end
      end
    end
  end
end
