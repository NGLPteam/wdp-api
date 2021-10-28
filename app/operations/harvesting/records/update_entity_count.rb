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

        connection = HarvestRecord.connection

        bindings = [[nil, harvest_record.id]]

        result = connection.exec_update(<<~SQL, "Updating HarvestRecord.entity_count", bindings)
        UPDATE harvest_records SET entity_count = (SELECT COUNT(*) FROM harvest_entities WHERE harvest_record_id = $1)
        WHERE id = $1
        SQL

        Success result
      end
    end
  end
end
