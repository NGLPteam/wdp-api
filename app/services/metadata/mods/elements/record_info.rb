# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RecordInfo < ::Metadata::MODS::Common::AbstractMapper
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :record_content_sources, ::Metadata::MODS::Elements::RecordContentSource, collection: true, expose_single: true
        attribute :record_creation_date, ::Metadata::MODS::Elements::Date
        attribute :record_change_date, ::Metadata::MODS::Elements::Date
        attribute :record_identifiers, ::Metadata::MODS::Elements::RecordIdentifier, collection: true, expose_single: true
        attribute :languages_of_cataloging, ::Metadata::MODS::Elements::Language, collection: true, expose_single: :language_of_cataloging
        attribute :record_origins, :string, collection: true, expose_single: true
        attribute :description_standards, :string, collection: true, expose_single: true
        attribute :record_info_notes, ::Metadata::MODS::Elements::RecordInfoNote, collection: true, expose_single: true

        attribute :content_sources, method: :record_content_sources
        attribute :content_source, method: :record_content_source

        attribute :identifiers, method: :record_identifiers
        attribute :identifier, method: :record_identifier

        attribute :notes, method: :record_info_notes
        attribute :note, method: :record_info_note

        attribute :origins, method: :record_origins
        attribute :origin, method: :origin

        xml do
          root "recordInfo"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group

          map_element "descriptionStandard", to: :description_standards
          map_element "languageOfCataloging", to: :languages_of_cataloging
          map_element "recordContentSource", to: :record_content_sources
          map_element "recordCreationDate", to: :record_creation_date
          map_element "recordChangeDate", to: :record_change_date
          map_element "recordIdentifier", to: :record_identifiers
          map_element "recordOrigin", to: :record_origins
          map_element "recordInfoNote", to: :record_info_notes
        end
      end
    end
  end
end
