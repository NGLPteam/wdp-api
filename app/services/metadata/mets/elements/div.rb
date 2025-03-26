# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not yet fully implemented
      class Div < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::OrderLabels

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :dmdid, ::Metadata::Shared::Xsd::IdRefs
        attribute :admid, ::Metadata::Shared::Xsd::IdRefs
        attribute :type, :string
        attribute :contentids, ::Metadata::METS::SimpleTypes::UriList
        attribute :label, :string
        attribute :mptrs, ::Metadata::METS::Elements::METSPointer, collection: true, expose_single: true
        attribute :fptrs, ::Metadata::METS::Elements::FilePointer, collection: true, expose_single: true
        attribute :divs, self, collection: true, expose_single: true

        xml do
          root "div", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "DMDID", to: :dmdid
          map_attribute "ADMID", to: :admid
          map_attribute "TYPE", to: :type
          map_attribute "CONTENTIDS", to: :contentids
          map_attribute "LABEL", to: :label

          map_element :mptr, to: :mptrs
          map_element :fptr, to: :fptrs
          map_element :div, to: :divs
        end
      end
    end
  end
end
