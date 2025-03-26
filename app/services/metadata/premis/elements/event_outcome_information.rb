# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EventOutcomeInformation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :event_outcome, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :detail, ::Metadata::PREMIS::Elements::EventOutcomeDetail

        xml do
          root "eventOutcomeInformation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :eventOutcome, to: :event_outcome
          map_element :eventOutcomeDetail, to: :detail
        end
      end
    end
  end
end
