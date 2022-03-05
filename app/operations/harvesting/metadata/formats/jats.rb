# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      class JATS < Harvesting::Metadata::BaseFormat
        include WDPAPI::Deps[
          augment_middleware: "harvesting.metadata.jats.augment_middleware",
          extract_entities: "harvesting.metadata.jats.extract_entities",
          validate_raw_metadata: "harvesting.metadata.jats.validate_raw_metadata",
        ]
      end
    end
  end
end
