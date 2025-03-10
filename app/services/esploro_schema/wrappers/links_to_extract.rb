# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#linksToExtract
    class LinksToExtract < EsploroSchema::Common::AbstractWrapper
      property! :link, EsploroSchema::ComplexTypes::EsploroLink, collection: true

      wraps! :link

      xml do
        root "linksToExtract", mixed: true

        map_element "linkToExtract", to: :link
      end
    end
  end
end
