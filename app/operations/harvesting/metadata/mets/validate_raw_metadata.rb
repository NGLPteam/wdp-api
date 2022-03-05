# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # Validate METS metadata before processing.
      class ValidateRawMetadata < Harvesting::Metadata::BaseXMLValidator
        default_namespace! Harvesting::Metadata::Namespaces[:mets]

        root_tag "mets"
      end
    end
  end
end
