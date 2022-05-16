# frozen_string_literal: true

module Harvesting
  module Records
    class Reextract
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:protocol)

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Result]
      def call(harvest_record)
        _extracted = yield protocol.extract_record.call harvest_record.identifier

        harvest_record.reload

        Success harvest_record
      rescue ActiveRecord::RecordNotFound
        # If re-extracting deleted the record, that's okay
        Success nil
      end
    end
  end
end
