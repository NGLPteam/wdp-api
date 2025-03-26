# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class AdministrativeMetadataSection < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id

        attribute :tech_sections, ::Metadata::METS::Elements::MetadataSection, collection: true, expose_single: true
        attribute :rights_sections, ::Metadata::METS::Elements::MetadataSection, collection: true, expose_single: true
        attribute :source_sections, ::Metadata::METS::Elements::MetadataSection, collection: true, expose_single: true
        attribute :digiprov_sections, ::Metadata::METS::Elements::MetadataSection, collection: true, expose_single: true

        xml do
          root "amdSec", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id

          map_element :techMD, to: :tech_sections
          map_element :rightsMD, to: :rights_sections
          map_element :sourceMD, to: :source_sections
          map_element :digiprovMD, to: :digiprov_sections
        end
      end
    end
  end
end
