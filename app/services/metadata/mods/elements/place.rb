# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Place < ::Metadata::MODS::Common::AbstractMapper
        attribute :supplied, :string
        attribute :place_term, ::Metadata::MODS::Elements::PlaceTerm, collection: true

        xml do
          root "place"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "supplied", to: :supplied
          map_element "placeTerm", to: :place_term
        end
      end
    end
  end
end
