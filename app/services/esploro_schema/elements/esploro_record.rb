# frozen_string_literal: true

module EsploroSchema
  module Elements
    # The top level wrapper for a `<record />` element.
    #
    # @see EsploroSchema::Elements::EsploroData
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroRecord
    class EsploroRecord < EsploroData
      # This is a custom type we have to add to support the data we're getting from providers.
      # It seems to be shaped like `esploroRecord`.
      #
      # @see EsploroSchema::Elements::EsploroData
      property! :data, EsploroSchema::Elements::EsploroData

      # This is an attribute that appears on <record /> elements but is not
      # in the Esploro Record XSD. Grabbing it anyway in case it becomes
      # important.
      property! :status, :string

      xml do
        root "record", mixed: true

        namespace EsploroSchema::Constants::NS_MARC_21_SLIM

        map_attribute "status", to: :status

        map_element "data", to: :data
      end

      private

      def wrapped_attribute_sources
        super << :data
      end
    end
  end
end
