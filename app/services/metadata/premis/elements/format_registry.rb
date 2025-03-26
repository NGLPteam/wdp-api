# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class FormatRegistry < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :simple_link, :string
        attribute :name, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :key, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "formatRegistry", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_attribute :simple_link, to: :simple_link

          map_element "formatRegistryName", to: :name
          map_element "formatRegistryKey", to: :key
          map_element "formatRegistryRole", to: :role
        end
      end
    end
  end
end
