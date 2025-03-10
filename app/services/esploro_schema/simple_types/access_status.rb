# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#AccessStatus
    class AccessStatus < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::AccessStatus
    end
  end
end
