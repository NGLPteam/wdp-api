# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class LicenseDocumentationIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "licenseDocumentationIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :licenseDocumentationIdentifierType, to: :type
          map_element :licenseDocumentationIdentifierValue, to: :value
          map_element :licenseDocumentationRole, to: :role
        end
      end
    end
  end
end
