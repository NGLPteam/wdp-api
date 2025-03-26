# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class LinkingAgentIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :link_agent_xml_id, ::Metadata::Shared::Xsd::IdRef
        attribute :simple_link, :string
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "linkingAgentIdentifier", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :link_agent_xml_id, to: :link_agent_xml_id
          map_attribute :simple_link, to: :simple_link
          map_element :linkingAgentIdentifierType, to: :type
          map_element :linkingAgentIdentifierValue, to: :value
          map_element :linkingAgentRole, to: :role
        end
      end
    end
  end
end
