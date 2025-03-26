# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class TitleInfo < ::Metadata::MODS::Common::AbstractMapper
        attribute :type, :string
        attribute :other_type, :string
        attribute :supplied, :string
        attribute :alt_rep_group, :string
        attribute :alt_format, :string
        attribute :content_type, :string
        attribute :name_title_group, :string
        attribute :usage, :string
        attribute :id, :string
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :titles, :string, collection: true, expose_single: true
        attribute :sub_titles, :string, collection: true, expose_single: true
        attribute :part_numbers, :string, collection: true, expose_single: true
        attribute :part_names, :string, collection: true, expose_single: true
        attribute :non_sorts, ::Metadata::MODS::Elements::NonSort, collection: true, expose_single: true

        # Alias these to spellings we use instead of how mods generates them.
        attribute :subtitles, method: :sub_titles
        attribute :subtitle, method: :sub_title

        xml do
          root "titleInfo"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "type", to: :type
          map_attribute "otherType", to: :other_type
          map_attribute "supplied", to: :supplied
          map_attribute "altRepGroup", to: :alt_rep_group
          map_attribute "altFormat", to: :alt_format
          map_attribute "contentType", to: :content_type
          map_attribute "nameTitleGroup", to: :name_title_group
          map_attribute "usage", to: :usage
          map_attribute "ID", to: :id
          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label

          map_element "nonSort", to: :non_sorts
          map_element "title", to: :titles
          map_element "subTitle", to: :sub_titles
          map_element "partNumber", to: :part_numbers
          map_element "partName", to: :part_names
        end
      end
    end
  end
end
