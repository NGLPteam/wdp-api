# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#relationships
    class Relationships < EsploroSchema::Common::AbstractWrapper
      # Asset relationships of type "ispartof".
      property! :relationship, EsploroSchema::ComplexTypes::EsploroRelationship

      wraps! :relationship

      xml do
        root "relationships", mixed: true

        map_element "relationship", to: :relationship
      end
    end
  end
end
