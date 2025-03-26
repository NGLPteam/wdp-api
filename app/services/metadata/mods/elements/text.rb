# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Text < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :display_label, :string
        attribute :type, :string

        xml do
          root "text"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "displayLabel", to: :display_label
          map_attribute "type", to: :type
        end
      end
    end
  end
end
