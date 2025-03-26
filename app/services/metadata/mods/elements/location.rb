# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Location < ::Metadata::MODS::Common::AbstractMapper
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :physical_location, ::Metadata::MODS::Elements::PhysicalLocation, collection: true
        attribute :shelf_locator, :string, collection: true
        attribute :url, ::Metadata::MODS::Elements::URL, collection: true
        attribute :holding_simple, ::Metadata::MODS::Elements::HoldingSimple
        attribute :holding_external, ::Metadata::MODS::Elements::HoldingExternal

        xml do
          root "location"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group

          map_element "physicalLocation", to: :physical_location
          map_element "shelfLocator", to: :shelf_locator
          map_element "url", to: :url
          map_element "holdingSimple", to: :holding_simple
          map_element "holdingExternal", to: :holding_external
        end
      end
    end
  end
end
