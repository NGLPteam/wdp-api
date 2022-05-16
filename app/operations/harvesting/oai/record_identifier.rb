# frozen_string_literal: true

module Harvesting
  module OAI
    class RecordIdentifier
      include Dry::Monads[:result]

      # @param [::OAI::Record] oai_record
      # @return [Dry::Monads::String]
      def call(oai_record)
        Success oai_record&.header&.identifier
      end
    end
  end
end
