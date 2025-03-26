# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      # @note Not extensively implemented
      class SmLocatorLink < ::Metadata::METS::Common::AbstractMapper
        attribute :id, ::Metadata::Shared::Xsd::Id

        xml do
          root "smLocatorLink", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_attribute "ID", to: :id
        end
      end
    end
  end
end
