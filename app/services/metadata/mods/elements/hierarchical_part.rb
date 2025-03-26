# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class HierarchicalPart < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :level, :string
        attribute :period, :string
        attribute :authority, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string

        xml do
          root "territory"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "level", to: :level
          map_attribute "period", to: :period
          map_attribute "authority", to: :authority
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
        end
      end
    end
  end
end
