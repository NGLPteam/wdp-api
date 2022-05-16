# frozen_string_literal: true

module Harvesting
  module Middleware
    module Builders
      # Build a middleware state from a {HarvestMapping}.
      class FromHarvestMapping < Harvesting::Middleware::BaseBuilder
        # @param [HarvestMapping] harvest_mapping
        def build_from(harvest_mapping)
          yield set_metadata_format! harvest_mapping

          yield set! :harvest_set, harvest_mapping.harvest_set
          yield set! :harvest_mapping, harvest_mapping
          yield set! :target_entity, harvest_mapping.target_entity

          yield set! :link_identifiers_globally, harvest_mapping.mapping_options.link_identifiers_globally

          Success nil
        end

        # @param [HarvestMapping] harvest_mapping
        # @return [HarvestSource]
        def parent_for(harvest_mapping)
          harvest_mapping.harvest_source
        end
      end
    end
  end
end
