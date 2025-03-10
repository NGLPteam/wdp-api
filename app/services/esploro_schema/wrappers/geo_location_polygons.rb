# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#geoLocationPolygons
    class GeoLocationPolygons < EsploroSchema::Common::AbstractWrapper
      property! :geo_location_polygon, EsploroSchema::ComplexTypes::EsploroPolygon, collection: true

      wraps! :geo_location_polygon

      xml do
        root "geoLocationPolygons", mixed: true

        map_element "geoLocationPolygon", to: :geo_location_polygon
      end
    end
  end
end
