# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class RelatedObjectIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :rel_object_xml_id, ::Metadata::Shared::Xsd::IdRef
        attribute :simple_link, :string
        attribute :related_object_identifier_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :related_object_identifier_value, :string
        attribute :related_object_sequence, ::Metadata::Shared::Xsd::NonNegativeInteger

        xml do
          root "relatedObjectIdentifierComplexType", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :rel_object_xml_id, to: :rel_object_xml_id
          map_attribute :simple_link, to: :simple_link
          map_element :relatedObjectIdentifierType, to: :related_object_identifier_type
          map_element :relatedObjectIdentifierValue, to: :related_object_identifier_value
          map_element :relatedObjectSequence, to: :related_object_sequence
        end
      end
    end
  end
end
