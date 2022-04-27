# frozen_string_literal: true

module Harvesting
  module Sources
    # Transform a {HarvestSource} into a {HarvestAttempt}.
    class CreateManualAttempt
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      # @param [HarvestSource] harvest_source
      # @param [HarvestTarget] target_entity
      # @param [HarvestSet, nil] set
      # @return [HarvestAttempt]
      def call(harvest_source, target_entity, set: nil)
        attributes = harvest_source.slice(:metadata_format)

        attributes[:target_entity] = target_entity

        attributes[:harvest_source_id] = harvest_source.id

        attributes[:harvest_set] = set if set.present?

        attributes[:kind] = "manual"

        attributes[:description] = "A test attempt for a harvest source"

        attempt = HarvestAttempt.new attributes

        harvest_source.modify_attempt_metadata! attempt.metadata

        monadic_save attempt
      end
    end
  end
end
