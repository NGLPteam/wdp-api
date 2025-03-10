# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#nationalAssessmentsProfiles
    class NationalAssessmentsProfiles < EsploroSchema::Common::AbstractWrapper
      property! :national_assessments_profile, EsploroSchema::ComplexTypes::NationalAssessmentsProfile, collection: true

      wraps! :national_assessments_profile

      xml do
        root "nationalAssessmentsProfiles", mixed: true

        map_element "nationalAssessmentsProfile", to: :national_assessments_profile
      end
    end
  end
end
