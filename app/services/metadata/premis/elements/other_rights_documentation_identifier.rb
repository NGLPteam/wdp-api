# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class OtherRightsDocumentationIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "otherRightsDocumentationIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :otherRightsDocumentationIdentifierType, to: :type
          map_element :otherRightsDocumentationIdentifierValue, to: :value
          map_element :otherRightsDocumentationRole, to: :role
        end
      end
    end
  end
end
