# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class AgentIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :simple_link, :string
        attribute :agent_identifier_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :agent_identifier_value, :string

        xml do
          root "agentIdentifier", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :simple_link, to: :simple_link

          map_element :agentIdentifierType, to: :type
          map_element :agentIdentifierValue, to: :value
        end
      end
    end
  end
end
