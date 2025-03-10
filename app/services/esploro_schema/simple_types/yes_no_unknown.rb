# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#YesNoUnknown
    class YesNoUnknown < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::YesNoUnknown
    end
  end
end
