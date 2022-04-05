# frozen_string_literal: true

module Harvesting
  module Actions
    # @see Harvesting::Metadata::Actions::Parse
    class ParseRecordMetadata < Harvesting::BaseAction
      runner do
        param :harvest_record, Harvesting::Types::Record
      end

      include Dry::Effects.Resolve(:metadata_format)

      extract_middleware_from :harvest_record

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def perform(harvest_record)
        metadata_format.parse.call harvest_record.raw_metadata_source
      end
    end
  end
end
