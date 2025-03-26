# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class File < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::FileCore

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :seq, :integer
        attribute :ownerid, :string
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs
        attribute :dmdid, ::Metadata::Shared::Xsd::IdRefs
        attribute :groupid, :string
        attribute :use, :string
        attribute :begin, :string
        attribute :end, :string
        attribute :betype, ::Metadata::METS::Enums::BeginEndType

        attribute :locations, ::Metadata::METS::Elements::FileLocation, collection: true, expose_single: true

        attribute :flocat, method: :location

        attribute :contents, ::Metadata::METS::Elements::FileContent, collection: true, expose_single: true

        attribute :fcontent, method: :content

        # Not really implemented.
        attribute :streams, ::Metadata::METS::Elements::Stream, collection: true

        # Not really implemented.
        attribute :transform_files, ::Metadata::METS::Elements::TransformFile, collection: true
        attribute :nested_files, self, collection: true

        attribute :pdf, method: :pdf?

        attribute :url, method: :derived_url

        xml do
          root "file", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "SEQ", to: :seq
          map_attribute "OWNERID", to: :ownerid
          map_attribute "ADMID", to: :admid
          map_attribute "DMDID", to: :dmdid
          map_attribute "GROUPID", to: :groupid
          map_attribute "USE", to: :use
          map_attribute "BEGIN", to: :begin
          map_attribute "END", to: :end
          map_attribute "BETYPE", to: :betype

          map_element :FLocat, to: :locations
          map_element :FContent, to: :contents
          map_element :stream, to: :streams
          map_element :transformFile, to: :transform_files
          map_element :file, to: :nested_files
        end

        # @return [String, nil]
        def derived_url
          Array(locations).detect(&:url?).try(:href)
        end

        def pdf?
          mimetype == "application/pdf"
        end
      end
    end
  end
end
