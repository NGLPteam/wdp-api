# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroGeoLocation
    class EsploroGeoLocation < EsploroSchema::Common::AbstractComplexType
      # Information about the asset's geolocation by points.
      property! :geo_location_points, EsploroSchema::Wrappers::GeoLocationPoints, collection: true

      # Information about the asset's geolocation by bounding-boxes.
      property! :geo_location_boxes, EsploroSchema::Wrappers::GeoLocationBoxes, collection: true

      # Information about the asset's geolocation by address.
      property! :geo_location_address, EsploroSchema::Wrappers::GeoLocationAddress, collection: true

      # For future use (not yet supported).
      property! :geo_location_polygons, EsploroSchema::Wrappers::GeoLocationPolygons, collection: true

      xml do
        root "geoLocation", mixed: true

        map_element "geoLocationPoints", to: :wrapped_geo_location_points
        map_element "geoLocationBoxs", to: :wrapped_geo_location_boxes
        map_element "geoLocationAddress", to: :wrapped_geo_location_address
        map_element "geoLocationPolygons", to: :wrapped_geo_location_polygons
      end
    end
  end
end
