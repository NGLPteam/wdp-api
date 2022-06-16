# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # Validate OAIDC metadata before processing.
      class ValidateRawMetadata < Harvesting::Metadata::BaseXMLValidator
        required_namespace! "oai_dc", Harvesting::Metadata::Namespaces[:oaidc]

        root_tag "dc"
      end
    end
  end
end
