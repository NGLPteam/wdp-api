# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class CitySection < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, ::Metadata::MODS::Elements::HierarchicalPart
        attribute :city_section_type, :string

        xml do
          root "citySection"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "citySectionType", to: :city_section_type
        end
      end
    end
  end
end
