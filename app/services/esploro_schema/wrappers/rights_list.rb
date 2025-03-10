# frozen_string_literal: true

module EsploroSchema
  module Wrappers
    # @see https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/#rightsList
    class RightsList < EsploroSchema::Common::AbstractWrapper
      # For future use (not yet supported).
      property! :rights, EsploroSchema::ComplexTypes::EsploroRights, collection: true

      wraps! :rights

      xml do
        root "rightsList", mixed: true

        map_element "rights", to: :rights
      end
    end
  end
end
