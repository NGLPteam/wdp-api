# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @abstract
    # @note This and its subclass, {EsploroSchema::ComplexTypes::HashMap}, don't have any elements
    #   defined. This appears intentional. So far our target data doesn't use it so we'll just
    #   ignore that for now.
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#abstractMap
    class AbstractMap < EsploroSchema::Common::AbstractComplexType; end
  end
end
