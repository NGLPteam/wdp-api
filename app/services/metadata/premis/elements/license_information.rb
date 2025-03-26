# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class LicenseInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :note, :string
        attribute :applicable_dates, ::Metadata::PREMIS::ComplexTypes::StartAndEndDate

        xml do
          root "licenseInformation", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :licenseNote, to: :note
          map_element :licenseApplicableDates, to: :applicable_dates
        end
      end
    end
  end
end
