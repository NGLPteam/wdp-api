# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class SmLinkGrp < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :arclinkorder, ::Metadata::METS::Enums::ArcLinkOrder, default: "unordered"
        attribute :sm_locator_link, ::Metadata::METS::Elements::SmLocatorLink, collection: true
        attribute :sm_arc_link, ::Metadata::METS::Elements::SmArcLink, collection: true

        xml do
          root "smLinkGrp", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "ARCLINKORDER", to: :arclinkorder

          map_element :smLocatorLink, to: :sm_locator_link
          map_element :smArcLink, to: :sm_arc_link
        end
      end
    end
  end
end
