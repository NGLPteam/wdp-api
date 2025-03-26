# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Note < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :display_label, :string
        attribute :type, :string
        attribute :id, :string
        attribute :script, :string

        xml do
          root "note"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "displayLabel", to: :display_label
          map_attribute "type", to: :type
          map_attribute "ID", to: :id
          map_attribute "script", to: :script
        end
      end
    end
  end
end
