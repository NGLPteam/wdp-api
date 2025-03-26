# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class METSDocumentId < ::Metadata::METS::Common::AbstractMapper
        attribute :content, :string

        xml do
          root "metsDocumentID", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_content to: :content
        end
      end
    end
  end
end
