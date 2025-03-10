# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#geoLocationPoints
    class GeoLocationPoints < EsploroSchema::Common::AbstractWrapper
      property! :geo_location_point, EsploroSchema::ComplexTypes::EsploroPoint, collection: true

      wraps! :geo_location_point

      xml do
        root "geoLocationPointsWrapper", mixed: true

        map_element "geoLocationPoint", to: :geo_location_point
      end
    end
  end
end
