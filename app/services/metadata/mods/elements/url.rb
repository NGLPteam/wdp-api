# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class URL < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :date_last_accessed, :string
        attribute :display_label, :string
        attribute :note, :string
        attribute :access, :string
        attribute :usage, :string

        xml do
          root "url"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content

          map_attribute "dateLastAccessed", to: :date_last_accessed
          map_attribute "displayLabel", to: :display_label
          map_attribute "note", to: :note
          map_attribute "access", to: :access
          map_attribute "usage", to: :usage
        end
      end
    end
  end
end
