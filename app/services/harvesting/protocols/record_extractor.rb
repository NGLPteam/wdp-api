# frozen_string_literal: true

module Harvesting
  module Protocols
    # @abstract
    #
    # Extract a single record for a given protocol.
    class RecordExtractor
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_attempt)
      include Dry::Effects.Resolve(:harvest_mapping)
      include Dry::Effects.Resolve(:harvest_set)
      include Dry::Effects.Resolve(:harvest_source)
      include Dry::Effects.Resolve(:metadata_format)
      include Dry::Effects.Resolve(:protocol)
      include Harvesting::WithLogger

      # @param [String] identifier
      # @return [Dry::Monads::Success(HarvestRecord)]
      def call(identifier)
        extracted = yield extract identifier

        return Success(nil) if extracted.blank?

        protocol.process_record.(extracted)
      end

      # @abstract
      # @param [String] identifier
      # @return [Dry::Monads::Result]
      def extract(identifier); end
    end
  end
end
