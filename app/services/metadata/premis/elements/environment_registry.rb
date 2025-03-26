# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EnvironmentRegistry < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :name, :string
        attribute :key, :string
        attribute :role, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority

        xml do
          root "environmentRegistry", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :environmentRegistryName, to: :name
          map_element :environmentRegistryKey, to: :key
          map_element :environmentRegistryRole, to: :role
        end
      end
    end
  end
end
