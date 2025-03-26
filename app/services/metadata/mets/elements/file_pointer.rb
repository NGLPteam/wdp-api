# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # The <fptr> or file pointer element represents digital content that
      # manifests its parent <div> element. The content represented by an
      # <fptr> element must consist of integral files or parts of files
      # that are represented by <file> elements in the <fileSec>. Via its
      # FILEID attribute,  an <fptr> may point directly to a single integral
      # <file> element that manifests a structural division. However, an
      # <fptr> element may also govern an <area> element,  a <par>, or a <seq>
      # which in turn would point to the relevant file or files. A child <area>
      # element can point to part of a <file> that manifests a division, while
      # the <par> and <seq> elements can point to multiple files or parts of
      # files that together manifest a division. More than one <fptr> element
      # can be associated with a <div> element. Typically sibling <fptr>
      # elements represent alternative versions, or manifestations,
      # of the same content.
      class FilePointer < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :fileid, ::Metadata::Shared::Xsd::IdRef
        attribute :contentids, ::Metadata::METS::SimpleTypes::UriList
        attribute :par, ::Metadata::METS::Elements::Par, collection: true
        attribute :seq, ::Metadata::METS::Elements::Seq, collection: true
        attribute :area, ::Metadata::METS::Elements::Area, collection: true

        xml do
          root "fptr", mixed: true
          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "FILEID", to: :fileid
          map_attribute "CONTENTIDS", to: :contentids

          map_element :par, to: :par
          map_element :seq, to: :seq
          map_element :area, to: :area
        end
      end
    end
  end
end
