# frozen_string_literal: true

module Harvesting
  module Sources
    # @api private
    # @see Harvesting::Actions::ExtractSets
    class ExtractSets
      include Dry::Effects.Resolve(:protocol)

      # @param [HarvestSource] harvest_source
      # @return [Dry::Monads::Result]
      def call(harvest_source)
        protocol.extract_sets.call(harvest_source)
      end
    end
  end
end
