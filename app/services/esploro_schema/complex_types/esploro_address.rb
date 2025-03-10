# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroAddress
    # @note the single S here in `geoLocationAddres` is not a typo.
    #   That's how the XML is for some reason.
    class EsploroAddress < EsploroGeoSpatial
      property! :address, :string

      xml do
        root "geoLocationAddres", mixed: true

        map_element "address", to: :address
      end
    end
  end
end
