# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class PhysicalDescription < ::Metadata::MODS::Common::AbstractMapper
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :form, ::Metadata::MODS::Elements::Form, collection: true
        attribute :reformatting_quality, :string, collection: true
        attribute :internet_media_type, :string, collection: true
        attribute :extent, ::Metadata::MODS::Elements::Extent, collection: true
        attribute :digital_origin, :string, collection: true
        attribute :note, ::Metadata::MODS::Elements::PhysicalDescriptionNote, collection: true

        xml do
          root "physicalDescription", ordered: true

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
          map_element "form", to: :form
          map_element "reformattingQuality", to: :reformatting_quality
          map_element "internetMediaType", to: :internet_media_type
          map_element "extent", to: :extent
          map_element "digitalOrigin", to: :digital_origin
          map_element "note", to: :note
        end
      end
    end
  end
end
