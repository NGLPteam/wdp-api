# frozen_string_literal: true

module Harvesting
  module Actions
    # Populates a collection of {HarvestSet sets} for an individual {HarvestSource source},
    # based on the source's protocol.
    class ExtractSets < Harvesting::BaseAction
      include MeruAPI::Deps[
        extract_sets: "harvesting.sources.extract_sets"
      ]

      runner do
        param :harvest_source, Harvesting::Types::Source
      end

      extract_middleware_from :harvest_source

      # @param [HarvestSource] harvest_source
      # @return [Dry::Monads::Success(Integer)] the count of sets harvested
      def perform(harvest_source)
        yield extract_sets.(harvest_source)

        harvest_source.touch :sets_refreshed_at

        Success harvest_source.harvest_sets.count
      end
    end
  end
end
