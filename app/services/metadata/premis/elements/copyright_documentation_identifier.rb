# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class CopyrightDocumentationIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "copyrightDocumentationIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :copyrightDocumentationIdentifierType, to: :type
          map_element :copyrightDocumentationIdentifierValue, to: :value
          map_element :copyrightDocumentationRole, to: :role
        end
      end
    end
  end
end
