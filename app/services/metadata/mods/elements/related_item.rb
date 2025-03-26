# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RelatedItem < ::Metadata::MODS::Common::AbstractMapper
        attribute :type, :string
        attribute :other_type, :string
        attribute :other_type_auth, :string
        attribute :other_type_auth_uri, :string
        attribute :other_type_uri, :string
        attribute :display_label, :string
        attribute :id, :string
        attribute :abstract, ::Metadata::MODS::Elements::Abstract, collection: true
        attribute :access_condition, ::Metadata::MODS::Elements::AccessCondition, collection: true
        attribute :classification, ::Metadata::MODS::Elements::Classification, collection: true
        attribute :extension, ::Metadata::MODS::Elements::Extension, collection: true
        attribute :genre, ::Metadata::MODS::Elements::Genre, collection: true
        attribute :identifier, ::Metadata::MODS::Elements::Identifier, collection: true
        attribute :language, ::Metadata::MODS::Elements::Language, collection: true
        attribute :location, ::Metadata::MODS::Elements::Location, collection: true
        attribute :name, ::Metadata::MODS::Elements::SubjectName, collection: true
        attribute :note, ::Metadata::MODS::Elements::Note, collection: true
        attribute :origin_info, ::Metadata::MODS::Elements::OriginInfo, collection: true
        attribute :part, ::Metadata::MODS::Elements::Part, collection: true
        attribute :physical_description, ::Metadata::MODS::Elements::PhysicalDescription, collection: true
        attribute :record_info, ::Metadata::MODS::Elements::RecordInfo, collection: true
        attribute :related_item, ::Metadata::MODS::Elements::RelatedItem, collection: true
        attribute :subject, ::Metadata::MODS::Elements::Subject, collection: true
        attribute :table_of_contents, ::Metadata::MODS::Elements::TableOfContents, collection: true
        attribute :target_audience, ::Metadata::MODS::Elements::TargetAudience, collection: true
        attribute :title_info, ::Metadata::MODS::Elements::TitleInfo, collection: true
        attribute :type_of_resource, ::Metadata::MODS::Elements::TypeOfResource, collection: true
        attribute :href, :string

        xml do
          root "relatedItem", mixed: true, ordered: true

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "type", to: :type
          map_attribute "otherType", to: :other_type
          map_attribute "otherTypeAuth", to: :other_type_auth
          map_attribute "otherTypeAuthURI", to: :other_type_auth_uri
          map_attribute "otherTypeURI", to: :other_type_uri
          map_attribute "displayLabel", to: :display_label
          map_attribute "ID", to: :id
          map_attribute "href", to: :href,
                                namespace: "http://www.w3.org/1999/xlink",
                                prefix: "xlink"

          map_element "abstract", to: :abstract
          map_element "accessCondition", to: :access_condition
          map_element "classification", to: :classification
          map_element "extension", to: :extension
          map_element "genre", to: :genre
          map_element "identifier", to: :identifier
          map_element "language", to: :language
          map_element "location", to: :location
          map_element "name", to: :name
          map_element "note", to: :note
          map_element "originInfo", to: :origin_info
          map_element "part", to: :part
          map_element "physicalDescription", to: :physical_description
          map_element "recordInfo", to: :record_info
          map_element "relatedItem", to: :related_item
          map_element "subject", to: :subject
          map_element "tableOfContents", to: :table_of_contents
          map_element "targetAudience", to: :target_audience
          map_element "titleInfo", to: :title_info
          map_element "typeOfResource", to: :type_of_resource
        end
      end
    end
  end
end
