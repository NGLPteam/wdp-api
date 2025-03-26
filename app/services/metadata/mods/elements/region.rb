# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Region < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, ::Metadata::MODS::Elements::HierarchicalPart
        attribute :region_type, :string

        xml do
          root "region"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "regionType", to: :region_type
        end
      end
    end
  end
end
