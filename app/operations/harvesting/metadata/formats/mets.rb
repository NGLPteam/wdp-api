# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      # The entry point for processing METS-formatted records.
      class METS < Harvesting::Metadata::BaseFormat
        include WDPAPI::Deps[
          augment_middleware: "harvesting.metadata.mets.augment_middleware",
          extract_entities: "harvesting.metadata.mets.extract_entities",
          validate_raw_metadata: "harvesting.metadata.mets.validate_raw_metadata",
        ]
      end
    end
  end
end
