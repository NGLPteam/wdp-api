# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class HierarchicalGeographic < ::Metadata::MODS::Common::AbstractMapper
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :extra_terrestrial_area, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :continent, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :country, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :province, :string, collection: true
        attribute :region, ::Metadata::MODS::Elements::Region, collection: true
        attribute :state, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :territory, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :county, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :city, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :city_section, ::Metadata::MODS::Elements::CitySection, collection: true
        attribute :island, ::Metadata::MODS::Elements::HierarchicalPart, collection: true
        attribute :area, ::Metadata::MODS::Elements::Area, collection: true

        xml do
          root "hierarchicalGeographic"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_element "extraTerrestrialArea", to: :extra_terrestrial_area
          map_element "continent", to: :continent
          map_element "country", to: :country
          map_element "province", to: :province
          map_element "region", to: :region
          map_element "state", to: :state
          map_element "territory", to: :territory
          map_element "county", to: :county
          map_element "city", to: :city
          map_element "citySection", to: :city_section
          map_element "island", to: :island
          map_element "area", to: :area
        end
      end
    end
  end
end
