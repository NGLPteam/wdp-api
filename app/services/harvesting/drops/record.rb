# frozen_string_literal: true

module Harvesting
  module Drops
    class Record < Liquid::Drop
      # The unique (per-source) identifier for the record.
      # @return [String]
      attr_reader :identifier

      # @param [HarvestRecord] record
      def initialize(record)
        @record = record

        @identifier = record.identifier
      end
    end
  end
end
