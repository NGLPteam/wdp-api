# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      # The entry point for processing METS-formatted records.
      class METS < Harvesting::Metadata::BaseFormat
        include WDPAPI::Deps[
          augment_middleware: "harvesting.metadata.mets.augment_middleware",
          extract_entities: "harvesting.metadata.mets.extract_entities",
          parse: "harvesting.metadata.mets.parse",
          validate_raw_metadata: "harvesting.metadata.mets.validate_raw_metadata",
        ]

        # @param [String] raw_metadata_source
        # @return [Dry::Monads::Result]
        def extract_values(raw_metadata_source)
          parse.(raw_metadata_source).bind(&:extracted_values)
        end
      end
    end
  end
end
