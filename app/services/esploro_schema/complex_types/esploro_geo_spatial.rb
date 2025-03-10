# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @abstract
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroGeoSpatial
    class EsploroGeoSpatial < EsploroSchema::Common::AbstractComplexType
      # Used for display purposes. Do not insert any values here.
      property! :display_string, :string
      # Geolocation type. Valid values are Address, Point, Bounding Box.
      property! :type, :string

      xml do
        root "esploroGeoSpatial", mixed: true

        map_element "displayString", to: :display_string
        map_element "type", to: :type
      end
    end
  end
end
