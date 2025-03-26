# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class SubjectName < ::Metadata::MODS::Common::AbstractMapper
        attribute :type, :string
        attribute :id, :string
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :name_part, ::Metadata::MODS::Elements::NamePart, collection: true
        attribute :display_form, :string, collection: true
        attribute :affiliation, :string, collection: true
        attribute :role, ::Metadata::MODS::Elements::Role, collection: true
        attribute :description, :string, collection: true
        attribute :name_identifier, ::Metadata::MODS::Elements::Identifier, collection: true

        xml do
          root "subjectName"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "type", to: :type
          map_attribute "ID", to: :id
          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_element "namePart", to: :name_part
          map_element "displayForm", to: :display_form
          map_element "affiliation", to: :affiliation
          map_element "role", to: :role
          map_element "description", to: :description
          map_element "nameIdentifier", to: :name_identifier
        end
      end
    end
  end
end
