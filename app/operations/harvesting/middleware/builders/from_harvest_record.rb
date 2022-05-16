# frozen_string_literal: true

module Harvesting
  module Middleware
    module Builders
      # Build a middleware state from a {HarvestRecord}.
      class FromHarvestRecord < Harvesting::Middleware::BaseBuilder
        # @param [HarvestRecord] harvest_record
        def build_from(harvest_record)
          yield set_metadata_format! harvest_record

          yield set! :raw_metadata, harvest_record.raw_metadata_source

          Success nil
        end

        # @param [HarvestRecord] harvest_record
        # @return [HarvestAttempt]
        def parent_for(harvest_record)
          harvest_record.harvest_attempt
        end
      end
    end
  end
end
