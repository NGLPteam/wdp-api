# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class CreatingApplication < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :date_created_by_application, ::Metadata::PREMIS::SimpleTypes::Edtf
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "creatingApplication", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :dateCreatedByApplication, to: :date_created_by_application
          map_element :creatingApplicationExtension, to: :extension
        end
      end
    end
  end
end
