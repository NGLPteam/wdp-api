# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#hashMap
    class HashMap < AbstractMap
      xml do
        root "hashMap", mixed: true
      end
    end
  end
end
