# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroPoint
    class EsploroPoint < EsploroGeoSpatial
      property! :longitude, :decimal
      property! :latitude, :decimal

      xml do
        root "geoLocationPoint", mixed: true

        map_element "longitude", to: :longitude
        map_element "latitude", to: :latitude
      end
    end
  end
end
