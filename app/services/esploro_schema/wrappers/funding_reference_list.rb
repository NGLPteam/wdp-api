# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#fundingreferenceList
    class FundingReferenceList < EsploroSchema::Common::AbstractWrapper
      # For future use (not yet supported).
      property! :funding_reference, EsploroSchema::ComplexTypes::EsploroFundingReference, collection: true

      wraps! :funding_reference

      xml do
        root "fundingreferenceList", mixed: true

        map_element "fundingreference", to: :funding_reference
      end
    end
  end
end
