# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class ObjectCharacteristics < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :composition_level, :integer
        attribute :fixity, ::Metadata::PREMIS::Elements::Fixity
        attribute :size, :integer
        attribute :format, ::Metadata::PREMIS::Elements::Format
        attribute :creating_application, ::Metadata::PREMIS::Elements::CreatingApplication
        attribute :inhibitors, ::Metadata::PREMIS::Elements::Inhibitors, collection: true
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        attribute :pdf, method: :pdf?

        delegate :pdf?, to: :format, prefix: true, allow_nil: true

        xml do
          root "objectCharacteristicsComplexType", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element "compositionLevel", to: :composition_level
          map_element "fixity", to: :fixity
          map_element "size", to: :size
          map_element "format", to: :format
          map_element "creatingApplication", to: :creating_application
          map_element "inhibitors", to: :inhibitors
          map_element "objectCharacteristicsExtension", to: :extension
        end

        def pdf?
          format_pdf?
        end
      end
    end
  end
end
