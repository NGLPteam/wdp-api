# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#links
    class Links < EsploroSchema::Common::AbstractWrapper
      property! :link, EsploroSchema::ComplexTypes::EsploroLink, collection: true

      wraps! :link

      xml do
        root "links", mixed: true

        map_element "link", to: :link
      end
    end
  end
end
