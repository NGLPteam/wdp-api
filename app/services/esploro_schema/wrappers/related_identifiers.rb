# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#relatedIdentifiers
    class RelatedIdentifiers < EsploroSchema::Common::AbstractWrapper
      # Identifier related to the asset. Relevant to internal relations only.
      # At least one identifier is mandatory for an internal relation.
      property! :related_identifier, EsploroSchema::ComplexTypes::EsploroRelatedIdentifiers, collection: true

      wraps! :related_identifier

      xml do
        root "relatedIdentifiers", mixed: true

        map_element "relatedIdentifier", to: :related_identifier
      end
    end
  end
end
