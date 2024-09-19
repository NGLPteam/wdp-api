# frozen_string_literal: true

module Harvesting
  module Middleware
    module Builders
      class FromHarvestSource < Harvesting::Middleware::BaseBuilder
        # @param [HarvestSource] harvest_source
        def build_from(harvest_source)
          yield set_protocol! harvest_source
          yield set_metadata_format! harvest_source

          yield set! :auto_create_volumes_and_issues, harvest_source.mapping_options.auto_create_volumes_and_issues
          yield set! :link_identifiers_globally, harvest_source.mapping_options.link_identifiers_globally
          yield set! :use_metadata_mappings, harvest_source.mapping_options.use_metadata_mappings
          yield set! :metadata_mappings, harvest_source.harvest_metadata_mappings

          Success nil
        end
      end
    end
  end
end
