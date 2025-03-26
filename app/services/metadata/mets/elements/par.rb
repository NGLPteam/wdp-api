# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note this has circular references. Not handling for now because lutaml-model doesn't support
      #   and we don't need it.
      class Par < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::OrderLabels

        attribute :id, ::Metadata::Shared::Xsd::Id
        # attribute :area, ::Metadata::METS::Elements::Area, collection: true
        # attribute :seq, ::Metadata::METS::Elements::Seq, collection: true

        xml do
          root "par", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id

          # map_element :area, to: :area
          # map_element :seq, to: :seq
        end
      end
    end
  end
end
