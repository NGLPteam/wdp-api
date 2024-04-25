# frozen_string_literal: true

module Harvesting
  module Records
    class UpdateEntityCount
      include Dry::Monads[:result]

      # @param [HarvestRecord] harvest_record
      # @return [Dry::Monads::Success(Integer)]
      def call(harvest_record)
        # :nocov:
        return Success(0) unless harvest_record.persisted?

        # :nocov:

        count = HarvestRecord.where(id: harvest_record.id).update_all(entity_count: HarvestEntity.where(harvest_record_id: harvest_record.id))

        Success count
      end
    end
  end
end
