# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class StatuteInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :jurisdiction, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :citation, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :determination_date, ::Metadata::PREMIS::SimpleTypes::Edtf
        attribute :note, :string
        attribute :documentation_identifier, ::Metadata::PREMIS::Elements::StatuteDocumentationIdentifier
        attribute :statute_applicable_dates, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate

        xml do
          root "statuteInformation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :statuteJurisdiction, to: :jurisdiction
          map_element :statuteCitation, to: :citation
          map_element :statuteInformationDeterminationDate, to: :determination_date
          map_element :statuteNote, to: :note
          map_element :statuteDocumentationIdentifier, to: :documentation_identifier
          map_element :statuteApplicableDates, to: :applicable_dates
        end
      end
    end
  end
end
