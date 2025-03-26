# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class FileContent < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::Location

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :use, :string
        attribute :bin_data, ::Metadata::Shared::Xsd::Base64Binary
        attribute :xml_data, ::Metadata::METS::Elements::XMLData

        xml do
          root "FContent", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "USE", to: :use

          map_element :binData, to: :bin_data
          map_element :xmlData, to: :xml_data
        end
      end
    end
  end
end
