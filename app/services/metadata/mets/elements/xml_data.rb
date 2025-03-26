# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class XMLData < ::Metadata::METS::Common::AbstractMapper
        attribute :content, :string

        xml do
          root "xmlData", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_all to: :content
        end
      end
    end
  end
end
