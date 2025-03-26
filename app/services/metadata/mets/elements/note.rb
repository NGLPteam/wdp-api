# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class Note < ::Metadata::METS::Common::AbstractMapper
        attribute :content, :string

        xml do
          root "note", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_content to: :content
        end
      end
    end
  end
end
