# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Area < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, ::Metadata::MODS::Elements::HierarchicalPart
        attribute :area_type, :string

        xml do
          root "area"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "areaType", to: :area_type
        end
      end
    end
  end
end
