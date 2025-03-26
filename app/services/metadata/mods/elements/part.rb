# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Part < ::Metadata::MODS::Common::AbstractMapper
        attribute :id, :string
        attribute :type, :string
        attribute :order, :integer
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :detail, ::Metadata::MODS::Elements::Detail, collection: true
        attribute :extent, ::Metadata::MODS::Elements::ExtentDefinition, collection: true
        attribute :date, ::Metadata::MODS::Elements::Date, collection: true
        attribute :text, ::Metadata::MODS::Elements::Text, collection: true

        xml do
          root "part"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "ID", to: :id
          map_attribute "type", to: :type
          map_attribute "order", to: :order
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
          map_element "detail", to: :detail
          map_element "extent", to: :extent
          map_element "date", to: :date
          map_element "text", to: :text
        end
      end
    end
  end
end
