# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#creators
    class Creators < EsploroSchema::Common::AbstractWrapper
      property! :creator, EsploroSchema::ComplexTypes::EsploroCreator, collection: true

      wraps! :creator

      xml do
        root "creators", mixed: true

        map_element "creator", to: :creator
      end
    end
  end
end
