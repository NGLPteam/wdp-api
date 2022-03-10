# frozen_string_literal: true

module Harvesting
  module OAI
    # Extract the raw source for an OAI-PMH record.
    class ExtractRawSource
      include Dry::Monads[:result]

      # @param [OAI::Record] oai_record
      # @return [Dry::Monads::Success(String)]
      def call(oai_record)
        Success oai_record._source.to_s
      end
    end
  end
end
