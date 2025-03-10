# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRights
    class EsploroRights < EsploroSchema::Common::AbstractComplexType
      # For future use (not yet supported).
      property! :rights, :string, collection: true

      # For future use (not yet supported).
      property! :uri, :string, collection: true

      # Not supported. We recommend using contributor of type rights holder instead.
      property! :holder, :string, collection: true

      xml do
        root "rights", mixed: true

        # Yes, there is a `<rights/>` element nested immediately under a `<rights/>` element.
        map_element "rights", to: :rights
        map_element "rights.uri", to: :uri
        map_element "rights.holder", to: :holder
      end
    end
  end
end
