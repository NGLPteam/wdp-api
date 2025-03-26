# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class RelatedEventIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :rel_event_xml_id, ::Metadata::Shared::Xsd::IdRef
        attribute :simple_link, :string
        attribute :related_event_identifier_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :related_event_identifier_value, :string
        attribute :related_event_sequence, ::Metadata::Shared::Xsd::NonNegativeInteger

        xml do
          root "relatedEventIdentifier", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :rel_event_xml_id, to: :rel_event_xml_id
          map_attribute :simple_link, to: :simple_link

          map_element :relatedEventIdentifierType, to: :related_event_identifier_type
          map_element :relatedEventIdentifierValue, to: :related_event_identifier_value
          map_element :relatedEventSequence, to: :related_event_sequence
        end
      end
    end
  end
end
