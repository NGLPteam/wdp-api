# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    class AdditionalIdentifiers < EsploroSchema::Common::AbstractWrapper
      property! :entry, EsploroSchema::ComplexTypes::Entry, collection: true

      wraps! :entry

      xml do
        root "additionalIdentifiers", mixed: true

        map_element "entry", to: :entry
      end
    end
  end
end
