# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#contributors
    class Contributors < EsploroSchema::Common::AbstractWrapper
      property! :contributor, EsploroSchema::ComplexTypes::EsploroContributor, collection: true

      wraps! :contributor

      xml do
        root "contributors", mixed: true

        map_element "contributor", to: :contributor
      end
    end
  end
end
