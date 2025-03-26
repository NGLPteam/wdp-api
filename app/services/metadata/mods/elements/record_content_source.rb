# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RecordContentSource < ::Metadata::MODS::Common::AbstractMapper
        attribute :authority, :string
        attribute :content, :string

        xml do
          root "recordContentSource"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content

          map_attribute "authority", to: :authority
        end
      end
    end
  end
end
