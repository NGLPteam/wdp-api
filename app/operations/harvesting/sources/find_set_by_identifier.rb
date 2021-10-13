# frozen_string_literal: true

module Harvesting
  module Sources
    class FindSetByIdentifier
      include Dry::Monads[:result]

      # @param [HarvestSource] harvest_source
      # @param [String] identifier
      # @return [HarvestSet]
      def call(harvest_source, identifier)
        Success harvest_source.harvest_sets.by_identifier(identifier).first!
      rescue ActiveRecord::RecordNotFound
        Failure[:unknown_identifier, "could not find set #{identifier.inspect}"]
      end
    end
  end
end
