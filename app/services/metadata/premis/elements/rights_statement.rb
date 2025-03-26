# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class RightsStatement < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :identifier, ::Metadata::PREMIS::Elements::RightsStatementIdentifier
        attribute :basis, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :copyright_information, ::Metadata::PREMIS::Elements::CopyrightInformation
        attribute :license_information, ::Metadata::PREMIS::Elements::LicenseInformation
        attribute :statute_information, ::Metadata::PREMIS::Elements::StatuteInformation
        attribute :other_rights_information, ::Metadata::PREMIS::Elements::OtherRightsInformation
        attribute :granted, ::Metadata::PREMIS::Elements::RightsGranted
        attribute :linking_object_identifier, ::Metadata::PREMIS::Elements::LinkingObjectIdentifier
        attribute :linking_agent_identifier, ::Metadata::PREMIS::Elements::LinkingAgentIdentifier

        xml do
          root "rightsStatement", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :rightsStatementIdentifier, to: :identifier
          map_element :rightsBasis, to: :basis
          map_element :copyrightInformation, to: :copyright_information
          map_element :licenseInformation, to: :license_information
          map_element :statuteInformation, to: :statute_information
          map_element :otherRightsInformation, to: :other_rights_information
          map_element :rightsGranted, to: :granted
          map_element :linkingObjectIdentifier, to: :linking_object_identifier
          map_element :linkingAgentIdentifier, to: :linking_agent_identifier
        end
      end
    end
  end
end
