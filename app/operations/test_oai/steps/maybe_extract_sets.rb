# frozen_string_literal: true

module TestOAI
  module Steps
    class MaybeExtractSets
      include Dry::Monads[:result]
      include MonadicPersistence
      include WDPAPI::Deps[
        extract_sets: "harvesting.actions.extract_sets",
      ]

      # @param [HarvestSource] source
      def call(source)
        return Success(nil) if source.harvest_sets.exists?

        extract_sets.call source
      end
    end
  end
end
