# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class SignificantProperties < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :value, :string
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "significantProperties", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element "significantPropertiesValue", to: :value
          map_element "significantPropertiesExtension", to: :extension
        end
      end
    end
  end
end
