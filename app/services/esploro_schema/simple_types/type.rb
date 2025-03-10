# frozen_string_literal: true

module EsploroSchema
  module SimpleTypes
    # @note Does not appear to be used, but is specifically defined in the XSD and mentioned in the documentation,
    #   so leaving here in case it gets adopted in the future.
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#type
    class Type < EsploroSchema::Common::AbstractEnum
      uses! EsploroSchema::Types::Type
    end
  end
end
