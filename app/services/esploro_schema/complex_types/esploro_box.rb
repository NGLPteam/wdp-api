# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroBox
    class EsploroBox < EsploroGeoSpatial
      property! :west_bound_longitude, :decimal
      property! :east_bound_longitude, :decimal
      property! :south_bound_longitude, :decimal
      property! :north_bound_longitude, :decimal

      xml do
        root "geoLocationBox", mixed: true

        map_element "westBoundLongitude", to: :west_bound_longitude
        map_element "eastBoundLongitude", to: :east_bound_longitude
        map_element "southBoundLongitude", to: :south_bound_longitude
        map_element "northBoundLongitude", to: :north_bound_longitude
      end
    end
  end
end
