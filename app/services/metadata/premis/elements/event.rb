# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Event < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :xml_id, ::Metadata::Shared::Xsd::Id
        attribute :version, ::Metadata::PREMIS::Enums::Version3
        attribute :identifier, ::Metadata::PREMIS::Elements::EventIdentifier
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :date_time, :string
        attribute :detail_information, ::Metadata::PREMIS::Elements::EventDetailInformation
        attribute :outcome_information, ::Metadata::PREMIS::Elements::EventOutcomeInformation
        attribute :linking_agent_identifier, ::Metadata::PREMIS::Elements::LinkingAgentIdentifier
        attribute :linking_object_identifier, ::Metadata::PREMIS::Elements::LinkingObjectIdentifier

        xml do
          root "event", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :xml_id, to: :xml_id
          map_attribute :version, to: :version

          map_element :eventIdentifier, to: :identifier
          map_element :eventType, to: :type
          map_element :eventDateTime, to: :date_time
          map_element :eventDetailInformation, to: :detail_information
          map_element :eventOutcomeInformation, to: :outcome_information
          map_element :linkingAgentIdentifier, to: :linking_agent_identifier
          map_element :linkingObjectIdentifier, to: :linking_object_identifier
        end
      end
    end
  end
end
