# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#RelationType
    class RelationType < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::RelationType
    end
  end
end
