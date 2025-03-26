# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # Like the <fptr> element, the METS pointer element <mptr> represents
      # digital content that manifests its parent <div> element. Unlike the
      # <fptr>, which either directly or indirectly points to content
      # represented in the <fileSec> of the parent METS document, the <mptr>
      # element points to content represented by an external METS document.
      # Thus, this element allows multiple discrete and separate METS
      # documents to be organized at a higher level by a separate METS
      # document. For example, METS documents representing the individual
      # issues in the series of a journal could be grouped together and
      # organized by a higher level METS document that represents the
      # entire journal series. Each of the <div> elements in the
      # <structMap> of the METS document representing the journal series
      # would point to a METS document representing an issue. It would do so
      # via a child <mptr> element. Thus the <mptr> element gives METS users
      # considerable flexibility in managing the depth of the <structMap>
      # hierarchy of individual METS documents. The <mptr> element points to
      # an external METS document by means of an xlink:href attribute and
      # associated XLink attributes.
      #
      # @note Not yet fully implemented
      class METSPointer < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::Location
        include Metadata::METS::AttributeGroups::SimpleLink

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :contentids, ::Metadata::METS::SimpleTypes::UriList

        xml do
          root "mptr", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "CONTENTIDS", to: :contentids
        end
      end
    end
  end
end
