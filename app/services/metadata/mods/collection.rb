# frozen_string_literal: true

module Metadata
  module MODS
    class Collection < ::Metadata::MODS::Common::AbstractMapper
      attribute :mods, ::Metadata::MODS::Root, collection: true

      xml do
        root "modsCollection", mixed: true, ordered: true

        namespace "http://www.loc.gov/mods/v3", "mods"

        map_element "mods", to: :mods
      end
    end
  end
end
