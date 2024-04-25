# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      # The entry point for processing OAI Dublin-Core-formatted records.
      class OAIDC < Harvesting::Metadata::BaseFormat
        include MeruAPI::Deps[
          augment_middleware: "harvesting.metadata.oaidc.augment_middleware",
          extract_entities: "harvesting.metadata.oaidc.extract_entities",
          parse: "harvesting.metadata.oaidc.parse",
          validate_raw_metadata: "harvesting.metadata.oaidc.validate_raw_metadata",
        ]

        oai_metadata_prefix "oai_dc"

        # @param [String] raw_metadata_source
        # @return [Dry::Monads::Result]
        def extract_values(raw_metadata_source)
          parse.(raw_metadata_source).bind(&:extracted_values)
        end
      end
    end
  end
end
