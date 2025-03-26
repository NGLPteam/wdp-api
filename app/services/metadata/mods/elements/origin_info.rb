# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class OriginInfo < ::Metadata::MODS::Common::AbstractMapper
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :event_type, :string
        attribute :places, ::Metadata::MODS::Elements::Place, collection: true, expose_single: true
        attribute :publishers, ::Metadata::MODS::Elements::Publisher, collection: true, expose_single: true
        attribute :dates_issued, ::Metadata::MODS::Elements::Date, collection: true, expose_single: :date_issued
        attribute :dates_created, ::Metadata::MODS::Elements::Date, collection: true, expose_single: :date_created
        attribute :dates_captured, ::Metadata::MODS::Elements::Date, collection: true, expose_single: :date_captured
        attribute :dates_valid, ::Metadata::MODS::Elements::Date, collection: true, expose_single: :date_valid
        attribute :dates_modified, ::Metadata::MODS::Elements::Date, collection: true, expose_single: :date_modified
        attribute :copyright_dates, ::Metadata::MODS::Elements::Date, collection: true, expose_single: true
        attribute :dates_other, ::Metadata::MODS::Elements::DateOther, collection: true, expose_single: :date_other
        attribute :editions, ::Metadata::MODS::Elements::Edition, collection: true, expose_single: true
        attribute :issuances, :string, collection: true, expose_single: true
        attribute :frequencies, :string, collection: true, expose_single: true

        xml do
          root "originInfo", ordered: true

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
          map_attribute "eventType", to: :event_type

          map_element "place", to: :places
          map_element "publisher", to: :publishers
          map_element "dateIssued", to: :dates_issued
          map_element "dateCreated", to: :dates_created
          map_element "dateCaptured", to: :dates_captured
          map_element "dateValid", to: :dates_valid
          map_element "dateModified", to: :dates_modified
          map_element "copyrightDate", to: :copyright_date
          map_element "dateOther", to: :dates_other
          map_element "issuance", to: :issuances
          map_element "edition", to: :editions
          map_element "frequency", to: :frequencies
        end
      end
    end
  end
end
