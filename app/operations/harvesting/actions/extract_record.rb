# frozen_string_literal: true

module Harvesting
  module Actions
    # Extract a single {HarvestRecord} by its identifier for a given {HarvestSource} (also by identifier).
    #
    # Currently, this only supports _re_extraction via {Harvesting::Actions::ReextractRecord} but the API
    # may later support ad-hoc extraction by identifier, should we find a need for it.
    class ExtractRecord < Harvesting::BaseAction
      include MeruAPI::Deps[
        reextract_record: "harvesting.actions.reextract_record",
      ]

      runner do
        param :source_identifier, Harvesting::Types::Coercible::String
        param :record_identifier, Harvesting::Types::String
      end

      # @param [String] source_identifier
      # @param [String] record_identifier
      # @return [Dry::Monads::Result]
      def perform(source_identifier, record_identifier)
        source = HarvestSource.fetch! source_identifier

        record = HarvestRecord.fetch_for_source! source, record_identifier

        reextract_record.(record)
      end
    end
  end
end
