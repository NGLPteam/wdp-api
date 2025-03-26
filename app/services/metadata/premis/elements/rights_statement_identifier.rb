# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class RightsStatementIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :simple_link, :string
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "rightsStatementIdentifier", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :simple_link, to: :simple_link
          map_element :rightsStatementIdentifierType, to: :type
          map_element :rightsStatementIdentifierValue, to: :value
        end
      end
    end
  end
end
