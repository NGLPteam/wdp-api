# frozen_string_literal: true

module Metadata
  module METS
    module Elements
      class AltRecordId < ::Metadata::METS::Common::AbstractMapper
        attribute :content, :string

        xml do
          root "altRecordID", mixed: true

          namespace "http://www.loc.gov/METS/"

          map_content to: :content
        end
      end
    end
  end
end
