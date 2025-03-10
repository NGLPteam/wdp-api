# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#EsploroResourceType
    class EsploroResourceType < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::EsploroResourceType
    end
  end
end
