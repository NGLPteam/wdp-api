# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Extent < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :unit, :string

        xml do
          root "extent"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "unit", to: :unit
        end
      end
    end
  end
end
