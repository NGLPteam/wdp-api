# frozen_string_literal: true

module Metadata
  module MODS
    class Root < ::Metadata::MODS::Common::AbstractMapper
      attribute :id, :string
      attribute :version, :string

      attribute :abstracts, ::Metadata::MODS::Elements::Abstract, collection: true, expose_single: true
      attribute :access_conditions, ::Metadata::MODS::Elements::AccessCondition, collection: true, expose_single: true
      attribute :classifications, ::Metadata::MODS::Elements::Classification, collection: true, expose_single: true
      attribute :extensions, ::Metadata::MODS::Elements::Extension, collection: true, expose_single: true
      attribute :genres, ::Metadata::MODS::Elements::Genre, collection: true, expose_single: true
      attribute :identifiers, ::Metadata::MODS::Elements::Identifier, collection: true, expose_single: true
      attribute :languages, ::Metadata::MODS::Elements::Language, collection: true, expose_single: true
      attribute :locations, ::Metadata::MODS::Elements::Location, collection: true, expose_single: true
      attribute :names, ::Metadata::MODS::Elements::Name, collection: true, expose_single: true
      attribute :notes, ::Metadata::MODS::Elements::Note, collection: true, expose_single: true
      attribute :origin_infos, ::Metadata::MODS::Elements::OriginInfo, collection: true, expose_single: true
      attribute :parts, ::Metadata::MODS::Elements::Part, collection: true, expose_single: true
      attribute :physical_descriptions, ::Metadata::MODS::Elements::PhysicalDescription, collection: true, expose_single: true
      attribute :record_info, ::Metadata::MODS::Elements::RecordInfo
      attribute :related_items, ::Metadata::MODS::Elements::RelatedItem, collection: true, expose_single: true
      attribute :subjects, ::Metadata::MODS::Elements::Subject, collection: true, expose_single: true
      attribute :tables_of_contents, ::Metadata::MODS::Elements::TableOfContents, collection: true, expose_single: true
      attribute :target_audiences, ::Metadata::MODS::Elements::TargetAudience, collection: true, expose_single: true
      attribute :title_infos, ::Metadata::MODS::Elements::TitleInfo, collection: true, expose_single: true
      attribute :types_of_resource, ::Metadata::MODS::Elements::TypeOfResource, collection: true, expose_single: true

      xml do
        root "mods", mixed: true

        namespace "http://www.loc.gov/mods/v3", "mods"

        map_attribute "ID", to: :id
        map_attribute "version", to: :version

        map_element "abstract", to: :abstracts
        map_element "accessCondition", to: :access_conditions
        map_element "classification", to: :classifications
        map_element "extension", to: :extensions
        map_element "genre", to: :genres
        map_element "language", to: :languages
        map_element "location", to: :locations
        map_element "name", to: :names
        map_element "note", to: :notes
        map_element "originInfo", to: :origin_infos
        map_element "part", to: :parts
        map_element "physicalDescription", to: :physical_descriptions
        map_element "subject", to: :subjects
        map_element "relatedItem", to: :related_items
        map_element "identifier", to: :identifiers
        map_element "recordInfo", to: :record_info
        map_element "tableOfContents", to: :tables_of_contents
        map_element "targetAudience", to: :target_audiences
        map_element "titleInfo", to: :title_infos
        map_element "typeOfResource", to: :types_of_resource
      end
    end
  end
end
