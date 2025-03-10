# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#entry
    class Entry < EsploroSchema::Common::AbstractComplexType
      property! :key, :string
      property! :value, :string

      xml do
        root "entry", mixed: true

        map_element "key", to: :key
        map_element "value", to: :value
      end
    end
  end
end
