# frozen_string_literal: true

module Harvesting
  module Sources
    # Transform a {HarvestSource} into a {HarvestAttempt}.
    class CreateManualAttempt
      include Dry::Monads[:do, :result]
      include MonadicPersistence

      # @param [HarvestSource] harvest_source
      # @return [HarvestAttempt]
      def call(harvest_source, collection, set: nil)
        attributes = harvest_source.slice(:metadata_format)

        attributes[:collection_id] = collection.id

        attributes[:harvest_source_id] = harvest_source.id

        attributes[:harvest_set] = set if set.present?

        attributes[:kind] = "manual"

        attributes[:description] = "A test attempt for a harvest source"

        attempt = HarvestAttempt.new attributes

        monadic_save attempt
      end
    end
  end
end
