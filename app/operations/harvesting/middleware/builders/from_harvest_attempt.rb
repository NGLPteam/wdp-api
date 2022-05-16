# frozen_string_literal: true

module Harvesting
  module Middleware
    module Builders
      # Build a middleware state from a {HarvestAttempt}.
      class FromHarvestAttempt < Harvesting::Middleware::BaseBuilder
        # @param [HarvestAttempt] harvest_attempt
        def build_from(harvest_attempt)
          yield set_metadata_format! harvest_attempt

          yield set_schema! :default_item, "default:item"
          yield set_schema! :default_collection, "default:collection"

          yield set! :harvest_set, harvest_attempt.harvest_set
          yield set! :harvest_mapping, harvest_attempt.harvest_mapping
          yield set! :target_entity, harvest_attempt.target_entity
          yield set! :record_extraction_progress, harvest_attempt.record_extraction_progress

          Success nil
        end

        # @see HarvestAttempt#middleware_parent
        # @param [HarvestAttempt] harvest_attempt
        # @return [HarvestMapping, HarvestSource]
        def parent_for(harvest_attempt)
          harvest_attempt.middleware_parent
        end
      end
    end
  end
end
