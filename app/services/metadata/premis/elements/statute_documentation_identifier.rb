# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class StatuteDocumentationIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "statuteDocumentationIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :statuteDocumentationIdentifierType, to: :type
          map_element :statuteDocumentationIdentifierValue, to: :value
          map_element :statuteDocumentationRole, to: :role
        end
      end
    end
  end
end
