# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class LinkingRightsStatementIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :link_permission_statement_xml_id, ::Metadata::Shared::Xsd::IdRef
        attribute :simple_link, :string
        attribute :type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :value, :string

        xml do
          root "linkingRightsStatementIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :link_permission_statement_xml_id, to: :link_permission_statement_xml_id
          map_attribute :simple_link, to: :simple_link
          map_element :linkingRightsStatementIdentifierType, to: :type
          map_element :linkingRightsStatementIdentifierValue, to: :value
        end
      end
    end
  end
end
