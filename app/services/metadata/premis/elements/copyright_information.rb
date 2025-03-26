# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class CopyrightInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :status, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :jurisdiction, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :determination_date, ::Metadata::PREMIS::SimpleTypes::Edtf
        attribute :note, :string
        attribute :documentation_identifier, ::Metadata::PREMIS::Elements::CopyrightDocumentationIdentifier
        attribute :applicable_dates, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate

        xml do
          root "copyrightInformation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :copyrightStatus, to: :status
          map_element :copyrightJurisdiction, to: :jurisdiction
          map_element :copyrightStatusDeterminationDate, to: :determination_date
          map_element :copyrightNote, to: :note
          map_element :copyrightDocumentationIdentifier, to: :documentation_identifier
          map_element :copyrightApplicableDates, to: :applicable_dates
        end
      end
    end
  end
end
