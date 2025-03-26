# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class Relationship < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :relationship_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :relationship_sub_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :related_event_identifier, ::Metadata::PREMIS::Elements::RelatedEventIdentifier
        attribute :related_environment_purpose, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :related_environment_characteristic, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :related_object_identifier, ::Metadata::PREMIS::Elements::RelatedObjectIdentifier

        attribute :sub_type, method: :relationship_sub_type
        attribute :subtype, method: :relationship_sub_type
        attribute :type, method: :relationship_type

        xml do
          root "relationship", mixed: true
          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :relationshipType, to: :relationship_type
          map_element :relationshipSubType, to: :relationship_sub_type
          map_element :relatedObjectIdentifier, to: :related_object_identifier
          map_element :relatedEventIdentifier, to: :related_event_identifier
          map_element :relatedEnvironmentPurpose, to: :related_environment_purpose
          map_element :relatedEnvironmentCharacteristic, to: :related_environment_characteristic
        end
      end
    end
  end
end
