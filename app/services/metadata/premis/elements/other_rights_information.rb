# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class OtherRightsInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :documentation_identifier, ::Metadata::PREMIS::Elements::OtherRightsDocumentationIdentifier
        attribute :basis, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :applicable_dates, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate
        attribute :note, :string

        xml do
          root "otherRightsInformation", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :otherRightsDocumentationIdentifier, to: :documentation_identifier
          map_element :otherRightsBasis, to: :basis
          map_element :otherRightsApplicableDates, to: :applicable_dates
          map_element :otherRightsNote, to: :note
        end
      end
    end
  end
end
