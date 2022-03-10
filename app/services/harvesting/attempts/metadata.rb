# frozen_string_literal: true

module Harvesting
  module Attempts
    # @api private
    class Metadata
      include StoreModel::Model

      ABSOLUTE_MAX_RECORD_COUNT = 5000

      attribute :max_records, :integer, default: ABSOLUTE_MAX_RECORD_COUNT

      # @!attribute [r] max_records
      # @return [Integer]
      def max_record_count
        max_records.to_i.clamp(1, ABSOLUTE_MAX_RECORD_COUNT)
      end
    end
  end
end
