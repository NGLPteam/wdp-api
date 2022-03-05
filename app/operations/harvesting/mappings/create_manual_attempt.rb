# frozen_string_literal: true

module Harvesting
  module Mappings
    # Transform a {HarvestMapping} into a {HarvestAttempt}.
    class CreateManualAttempt
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      # @param [HarvestMapping] harvest_mapping
      # @return [HarvestAttempt]
      def call(harvest_mapping)
        attributes = harvest_mapping.slice(:harvest_source_id, :harvest_set_id, :target_entity_id, :target_entity_type, :metadata_format)

        attributes[:harvest_mapping_id] = harvest_mapping.id

        attributes[:kind] = "manual"

        attributes[:description] = "A test attempt for a harvest mapping"

        attempt = HarvestAttempt.new attributes

        monadic_save attempt
      end
    end
  end
end
