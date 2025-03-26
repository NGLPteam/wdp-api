# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class TargetAudience < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :authority, :string
        attribute :display_label, :string
        attribute :alt_rep_group, :string

        xml do
          root "targetAudience"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "authority", to: :authority
          map_attribute "displayLabel", to: :display_label
          map_attribute "altRepGroup", to: :alt_rep_group
        end
      end
    end
  end
end
