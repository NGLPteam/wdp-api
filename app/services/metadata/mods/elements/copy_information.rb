# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class CopyInformation < ::Metadata::MODS::Common::AbstractMapper
        attribute :form, ::Metadata::MODS::Elements::Form
        attribute :sub_location, :string, collection: true
        attribute :shelf_locator, :string, collection: true
        attribute :electronic_locator, :string, collection: true
        attribute :note, ::Metadata::MODS::Elements::Note, collection: true
        attribute :enumeration_and_chronology, ::Metadata::MODS::Elements::EnumerationAndChronology,
                  collection: true
        attribute :item_identifier, ::Metadata::MODS::Elements::ItemIdentifier, collection: true

        xml do
          root "copyInformation"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_element "form", to: :form
          map_element "subLocation", to: :sub_location
          map_element "shelfLocator", to: :shelf_locator
          map_element "electronicLocator", to: :electronic_locator
          map_element "note", to: :note
          map_element "enumerationAndChronology", to: :enumeration_and_chronology
          map_element "itemIdentifier", to: :item_identifier
        end
      end
    end
  end
end
