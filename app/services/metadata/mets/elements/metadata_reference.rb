# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not presently supported fully. We haven't needed it.
      class MetadataReference < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::FileCore
        include Metadata::METS::AttributeGroups::Location
        include Metadata::METS::AttributeGroups::Metadata
        include Metadata::METS::AttributeGroups::SimpleLink

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :label, :string
        attribute :xptr, :string

        xml do
          root "mdRef", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "LABEL", to: :label
          map_attribute "XPTR", to: :xptr
        end
      end
    end
  end
end
