# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class LinkingEnvironmentIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :link_event_xml_id, ::Metadata::Shared::Xsd::IdRef
        attribute :simple_link, :string
        attribute :type, :string
        attribute :value, :string
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "linkingEnvironmentIdentifierComplexType", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :link_event_xml_id, to: :link_event_xml_id
          map_attribute :simple_link, to: :simple_link
          map_element :linkingEnvironmentIdentifierType, to: :type
          map_element :linkingEnvironmentIdentifierValue, to: :value
          map_element :linkingEnvironmentRole, to: :role
        end
      end
    end
  end
end
