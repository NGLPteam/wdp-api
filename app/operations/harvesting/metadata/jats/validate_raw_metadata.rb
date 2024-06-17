# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # Validate JATS metadata before processing.
      class ValidateRawMetadata < Harvesting::Metadata::BaseXMLValidator
        default_namespace! :jats

        root_tag "article"

        def prepare!(doc)
          if doc.namespaces["xmlns"].blank?
            default = doc.namespaces["xmlns:jats"].presence || required_namespaces[:xmlns]

            doc.root.add_namespace_definition nil, default
          end

          super
        end

        def transform(doc)
          Success doc.to_xml
        end
      end
    end
  end
end
