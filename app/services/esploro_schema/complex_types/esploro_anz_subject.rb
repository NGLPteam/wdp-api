# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroANZsubject
    class EsploroANZSubject < EsploroSchema::Common::AbstractComplexType
      # Code for the ANZ Field of Research or ANZ Socio-Economic Objective. Use value from code table.
      property! :code, :string

      # Percentage for the ANZ Field of Research or ANZ Socio-Economic Objective.
      # Can either be empty, or greater than 0 and no more than 100.
      # Cumulative percentages should not be more than 100.
      property! :percentage, :decimal

      xml do
        root "esploroANZsubject", mixed: true

        map_element "code", to: :code
        map_element "percentage", to: :percentage
      end
    end
  end
end
