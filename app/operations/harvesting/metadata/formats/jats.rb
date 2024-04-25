# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      class JATS < Harvesting::Metadata::BaseFormat
        include MeruAPI::Deps[
          augment_middleware: "harvesting.metadata.jats.augment_middleware",
          extract_entities: "harvesting.metadata.jats.extract_entities",
          parse: "harvesting.metadata.jats.parse",
          validate_raw_metadata: "harvesting.metadata.jats.validate_raw_metadata",
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
