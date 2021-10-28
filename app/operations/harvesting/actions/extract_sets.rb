# frozen_string_literal: true

module Harvesting
  module Actions
    # Populates a collection of {HarvestSet sets} for an individual {HarvestSource source},
    # based on the source's protocol.
    class ExtractSets < Harvesting::BaseAction
      include Dry::Effects.Resolve(:protocol)

      # @param [HarvestSource] harvest_source
      # @return [Integer] the count of sets harvested
      def call(harvest_source)
        wrap_middleware.call(harvest_source) do
          yield protocol.extract_sets.call(harvest_source)
        end

        harvest_source.touch :sets_refreshed_at

        Success harvest_source.harvest_sets.count
      end
    end
  end
end
