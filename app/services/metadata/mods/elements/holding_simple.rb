# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class HoldingSimple < ::Metadata::MODS::Common::AbstractMapper
        attribute :copy_information, ::Metadata::MODS::Elements::CopyInformation, collection: true

        xml do
          root "holdingSimple"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_element "copyInformation", to: :copy_information
        end
      end
    end
  end
end
