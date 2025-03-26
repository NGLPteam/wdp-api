# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class FileLocation < ::Metadata::METS::Common::AbstractMapper
        include Metadata::METS::AttributeGroups::Location
        include Metadata::METS::AttributeGroups::SimpleLink

        attribute :id, ::Metadata::Shared::Xsd::Id
        attribute :use, :string

        xml do
          root "FLocat", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
          map_attribute "USE", to: :use
        end

        def url?
          loctype == "URL"
        end
      end
    end
  end
end
