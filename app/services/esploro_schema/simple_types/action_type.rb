# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#ActionType
    class ActionType < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::ActionType
    end
  end
end
