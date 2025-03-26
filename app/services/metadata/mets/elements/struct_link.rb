# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not extensively implemented
      class StructLink < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :sm_link, ::Metadata::METS::Elements::SmLink
        attribute :sm_link_grp, ::Metadata::METS::Elements::SmLinkGrp

        xml do
          root "structLink", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id

          map_element :smLink, to: :sm_link
          map_element :smLinkGrp, to: :sm_link_grp
        end
      end
    end
  end
end
