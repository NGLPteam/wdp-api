# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # For future use (not yet supported).
    # https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroPolygon
    class EsploroPolygon < EsploroGeoSpatial
      xml do
        root "geoLocationPolygon", mixed: true
      end
    end
  end
end
