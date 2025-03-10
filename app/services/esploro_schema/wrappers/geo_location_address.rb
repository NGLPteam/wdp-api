# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#geoLocationAddress
    # @note the single S here in `geoLocationAddres` is not a typo.
    #   That's how the XML is for some reason.
    class GeoLocationAddress < EsploroSchema::Common::AbstractWrapper
      property! :geo_location_addres, EsploroSchema::ComplexTypes::EsploroAddress, collection: true

      wraps! :geo_location_addres

      xml do
        root "geoLocationAddress", mixed: true

        map_element "geoLocationAddres", to: :geo_location_addres
      end
    end
  end
end
