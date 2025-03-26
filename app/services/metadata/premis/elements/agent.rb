# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Agent < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :xml_id, ::Metadata::Shared::Xsd::Id
        attribute :version, ::Metadata::PREMIS::Enums::Version3
        attribute :identifiers, ::Metadata::PREMIS::Elements::AgentIdentifier, collection: true
        attribute :name, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :version, :string
        attribute :note, :string
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension
        attribute :linking_event_identifier, ::Metadata::PREMIS::Elements::LinkingEventIdentifier
        attribute :linking_rights_statement_identifier, ::Metadata::PREMIS::Elements::LinkingRightsStatementIdentifier
        attribute :linking_environment_identifier, ::Metadata::PREMIS::Elements::LinkingEnvironmentIdentifier

        xml do
          root "agent", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :xml_id, to: :xml_id
          map_attribute :version, to: :version

          map_element :agentIdentifier, to: :identifiers
          map_element :agentName, to: :name
          map_element :agentType, to: :type
          map_element :agentVersion, to: :version
          map_element :agentNote, to: :note
          map_element :agentExtension, to: :extension
          map_element :linkingEventIdentifier, to: :linking_event_identifier
          map_element :linkingRightsStatementIdentifier, to: :linking_rights_statement_identifier
          map_element :linkingEnvironmentIdentifier, to: :linking_environment_identifier
        end
      end
    end
  end
end
