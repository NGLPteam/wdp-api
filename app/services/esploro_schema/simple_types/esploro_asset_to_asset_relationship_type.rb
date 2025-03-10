# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroAssetToAssetRelationshipType
    class EsploroAssetToAssetRelationshipType < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::EsploroAssetToAssetRelationshipType
    end
  end
end
