# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#keywordsTranslation
    class KeywordsTranslation < EsploroSchema::Common::AbstractComplexType
      # The language of the keywords to follow. Use 3 letter language code.
      property! :language, :string

      # The keyword in the language specified. Multiple values are allowed.
      property! :values, :string, collection: true

      xml do
        root "keywordsTranslation", mixed: true

        map_element "language", to: :language
        map_element "values", to: :values
      end
    end
  end
end
