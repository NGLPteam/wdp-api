# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class EnumerationAndChronology < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :unit_type, :string

        xml do
          root "enumerationAndChronology"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "unitType", to: :unit_type
        end
      end
    end
  end
end
