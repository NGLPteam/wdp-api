# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @note Section describing the abstract/s and their language. Use when the language of the abstract/s is known.
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#descriptionAbstractTranslation
    class DescriptionAbstractTranslation < EsploroSchema::Common::AbstractComplexType
      # @see The language of the abstract/s to follow. Use 3 letter language code.
      property! :language, :string

      # @see The abstract/s in the language specified. Multiple values are allowed.
      property! :values, :string, collection: true

      xml do
        root "descriptionAbstractTranslations", mixed: true

        map_element "language", to: :language
        map_element "values", to: :values
      end
    end
  end
end
