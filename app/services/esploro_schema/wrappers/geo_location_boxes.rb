# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#geoLocationBoxs
    class GeoLocationBoxes < EsploroSchema::Common::AbstractWrapper
      property! :geo_location_box, EsploroSchema::ComplexTypes::EsploroBox

      wraps! :geo_location_box

      xml do
        # Not a typo. This is how the XML is written.
        root "geoLocationBoxs", mixed: true

        map_element "geoLocationBox", to: :geo_location_box
      end
    end
  end
end
