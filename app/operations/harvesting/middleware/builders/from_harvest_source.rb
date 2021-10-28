# frozen_string_literal: true

module Harvesting
  module Middleware
    module Builders
      class FromHarvestSource < Harvesting::Middleware::BaseBuilder
        # @param [HarvestSource] harvest_source
        def build_from(harvest_source)
          yield set_protocol! harvest_source
          yield set_metadata_format! harvest_source

          Success nil
        end
      end
    end
  end
end
