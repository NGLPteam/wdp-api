# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Name < ::Metadata::MODS::Common::AbstractMapper
        attribute :id, :string
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :name_title_group, :string
        attribute :usage, :string
        attribute :type, :string
        attribute :name_parts, ::Metadata::MODS::Elements::NamePart, collection: true, expose_single: true
        attribute :display_forms, :string, collection: true, expose_single: true
        attribute :affiliations, :string, collection: true, expose_single: true
        attribute :roles, ::Metadata::MODS::Elements::Role, collection: true, expose_single: true
        attribute :descriptions, :string, collection: true, expose_single: true
        attribute :name_identifiers, ::Metadata::MODS::Elements::Identifier, collection: true, expose_single: true
        attribute :alternative_names, ::Metadata::MODS::Elements::AlternativeName, collection: true, expose_single: true
        attribute :etal, :string
        attribute :href, :string

        attribute :identifier, method: :name_identifier
        attribute :identifiers, method: :name_identifiers

        xml do
          root "name"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "href", to: :href,
                                namespace: "http://www.w3.org/1999/xlink",
                                prefix: "xlink"

          map_attribute "ID", to: :id
          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
          map_attribute "nameTitleGroup", to: :name_title_group
          map_attribute "usage", to: :usage
          map_attribute "type", to: :type

          map_element "namePart", to: :name_parts
          map_element "displayForm", to: :display_forms
          map_element "affiliation", to: :affiliations
          map_element "role", to: :roles
          map_element "description", to: :descriptions
          map_element "nameIdentifier", to: :name_identifiers
          map_element "alternativeName", to: :alternative_names
          map_element "etal", to: :etal
        end
      end
    end
  end
end
