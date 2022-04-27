# frozen_string_literal: true

module Harvesting
  module Options
    # @api private
    class Read
      include StoreModel::Model
      include Shared::EnhancedStoreModel

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
