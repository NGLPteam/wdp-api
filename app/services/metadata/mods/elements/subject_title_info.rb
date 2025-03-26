# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class SubjectTitleInfo < ::Metadata::MODS::Common::AbstractMapper
        attribute :id, :string
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :display_label, :string
        attribute :type, :string
        attribute :title, :string, collection: true
        attribute :sub_title, :string, collection: true
        attribute :part_number, :string, collection: true
        attribute :part_name, :string, collection: true
        attribute :non_sort, :string, collection: true

        xml do
          root "subjectTitleInfo"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "ID", to: :id
          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "displayLabel", to: :display_label
          map_attribute "type", to: :type
          map_element "title", to: :title
          map_element "subTitle", to: :sub_title
          map_element "partNumber", to: :part_number
          map_element "partName", to: :part_name
          map_element "nonSort", to: :non_sort
        end
      end
    end
  end
end
