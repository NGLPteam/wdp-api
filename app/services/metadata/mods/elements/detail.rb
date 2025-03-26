# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Detail < ::Metadata::MODS::Common::AbstractMapper
        attribute :type, :string
        attribute :level, :integer
        attribute :number, :string, collection: true
        attribute :caption, :string, collection: true
        attribute :title, :string, collection: true

        xml do
          root "detail"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_attribute "type", to: :type
          map_attribute "level", to: :level
          map_element "number", to: :number
          map_element "caption", to: :caption
          map_element "title", to: :title
        end
      end
    end
  end
end
