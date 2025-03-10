# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRelatedIdentifiers
    class EsploroRelatedIdentifiers < EsploroSchema::Common::AbstractComplexType
      # Value of the related identifier.
      property! :related_identifer, :string

      # Type of related identifier. Use value from code table.
      property! :related_identifer_type, :string

      xml do
        root "relatedIdentifier", mixed: true

        map_element "relatedIdentifer", to: :related_identifer
        map_element "relatedIdentiferType", to: :related_identifer_type
      end
    end
  end
end
