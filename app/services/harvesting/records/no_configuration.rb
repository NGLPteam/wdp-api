# frozen_string_literal: true

module Harvesting
  module Records
    class NoConfiguration < Harvesting::Error
      # @return [HarvestRecord]
      attr_reader :record

      # @param [HarvestRecord] record
      def initialize(record)
        @record = record

        super("No configuration for HarvestRecord #{record.id}")
      end
    end
  end
end
