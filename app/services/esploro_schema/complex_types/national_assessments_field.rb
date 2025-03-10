# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#nationalAssessmentsFields
    class NationalAssessmentsField < EsploroSchema::Common::AbstractComplexType
      # National assessment field name, as configured in Esploro.
      # Field name must be part of the Assessment Profile chosen.
      property! :tag_name, :string

      # Value for national assessment field. Value must be in the format specified for the field in the configuration.
      # Format for date is MM/DD/YYYY.
      # Format for date range is MM/DD/YYYY – MM/DD/YYYY.
      property! :value, :string

      xml do
        root "nationalAssessmentsField", mixed: true

        map_element "tagName", to: :tag_name
        map_element "value", to: :value
      end
    end
  end
end
