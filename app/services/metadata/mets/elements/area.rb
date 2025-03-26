# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not extensively implemented yet because we haven't needed to parse it
      #   for harvesting.
      class Area < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::OrderLabels

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :fileid, ::Metadata::Shared::Xsd::IdRef
        attribute :shape, ::Metadata::METS::Enums::Shape
        attribute :coords, :string
        attribute :begin, :string
        attribute :end, :string
        attribute :betype, ::Metadata::METS::Enums::BeginEndType
        attribute :extent, :string
        attribute :exttype, ::Metadata::METS::Enums::ExtentType
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs
        attribute :contentids, ::Metadata::METS::SimpleTypes::UriList

        xml do
          root "area", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "FILEID", to: :fileid
          map_attribute "SHAPE", to: :shape
          map_attribute "COORDS", to: :coords
          map_attribute "BEGIN", to: :begin
          map_attribute "END", to: :end
          map_attribute "BETYPE", to: :betype
          map_attribute "EXTENT", to: :extent
          map_attribute "EXTTYPE", to: :exttype
          map_attribute "ADMID", to: :admid
          map_attribute "CONTENTIDS", to: :contentids
        end
      end
    end
  end
end
