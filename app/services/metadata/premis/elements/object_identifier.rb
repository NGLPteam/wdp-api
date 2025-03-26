# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class ObjectIdentifier < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :simple_link, :string
        attribute :object_identifier_type, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :object_identifier_value, :string

        attribute :type, method: :object_identifier_type_content
        attribute :value, method: :object_identifier_value

        delegate :content, to: :object_identifier_type, prefix: true, allow_nil: true

        xml do
          root "objectIdentifier", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :simple_link, to: :simple_link

          map_element :objectIdentifierType, to: :object_identifier_type
          map_element :objectIdentifierValue, to: :object_identifier_value
        end
      end
    end
  end
end
