# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Validate JATS metadata before processing.
      class ValidateRawMetadata < Harvesting::Metadata::BaseXMLValidator
        default_namespace! :jats

        root_tag "article"

        def transform(doc)
          Success doc.to_xml
        end
      end
    end
  end
end
