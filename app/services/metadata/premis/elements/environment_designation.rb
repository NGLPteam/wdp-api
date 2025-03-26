# frozen_string_literal: true

module Metadata
  module PREMIS
    module Elements
      class EnvironmentDesignation < ::Metadata::PREMIS::Common::AbstractMapper
        attribute :environment_name, ::Metadata::PREMIS::ComplexTypes::StringPlusAuthority
        attribute :environment_version, :string
        attribute :environment_origin, :string

        attribute :note, :string
        attribute :extension, ::Metadata::PREMIS::ComplexTypes::Extension

        xml do
          root "environmentDesignation", mixed: true

          namespace "http://www.loc.gov/premis/v3", "premis"

          map_element :environmentName, to: :environment_name
          map_element :environmentVersion, to: :environment_version
          map_element :environmentOrigin, to: :environment_origin
          map_element :environmentDesignationNote, to: :note
          map_element :environmentDesignationExtension, to: :extension
        end
      end
    end
  end
end
