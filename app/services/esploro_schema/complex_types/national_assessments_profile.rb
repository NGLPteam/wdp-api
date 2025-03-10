# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#nationalAssessmentsProfile
    class NationalAssessmentsProfile < EsploroSchema::Common::AbstractComplexType
      # The assessment profile code configured in Esploro. Code must match an active or inactive profile, not a draft.
      property! :profile_code, :string

      # Each national assessments field should be included in this section, where the field name is inserted in "tagName" and the field value is inserted in "value".
      # Multiple fields are allowed.
      property! :national_assessments_fields, EsploroSchema::ComplexTypes::NationalAssessmentsField, collection: true

      xml do
        root "nationalAssessmentsProfile", mixed: true

        map_element "profileCode", to: :profile_code
        map_element "nationalAssessmentsField", to: :national_assessments_fields
      end
    end
  end
end
