# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Classification < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :authority, :string
        attribute :edition, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string
        attribute :usage, :string
        attribute :generator, :string

        xml do
          root "classification"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "authority", to: :authority
          map_attribute "edition", to: :edition
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
          map_attribute "usage", to: :usage
          map_attribute "generator", to: :generator
        end
      end
    end
  end
end
