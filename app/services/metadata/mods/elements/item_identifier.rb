# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class ItemIdentifier < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :type, :string

        xml do
          root "itemIdentifier"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "type", to: :type
        end
      end
    end
  end
end
