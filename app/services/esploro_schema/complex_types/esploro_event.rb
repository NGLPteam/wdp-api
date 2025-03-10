# frozen_string_literal: true

module EsploroSchema
  module ComplexTypes
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#esploroEvent
    class EsploroEvent < EsploroSchema::Common::AbstractComplexType
      # Asset event name.
      property! :name, :string

      # The event location.
      property! :location, :string

      # The event type.
      property! :type, :string

      # The number of the event, if it's recurring. Free-text.
      property! :number, :string

      # The date of the event. The required format is YYYYMMDD.
      property! :date, :string

      xml do
        root "esploroEvent", mixed: true

        map_element "event.name", to: :name
        map_element "event.location", to: :location
        map_element "event.type", to: :type
        map_element "event.number", to: :number
        map_element "event.date", to: :date
      end
    end
  end
end
