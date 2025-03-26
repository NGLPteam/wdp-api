# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class AccessCondition < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :display_label, :string
        attribute :lang, :string
        attribute :script, :string
        attribute :transliteration, :string
        attribute :type, :string
        attribute :alt_rep_group, :string
        attribute :alt_format, :string
        attribute :content_type, :string

        xml do
          root "accessCondition"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "displayLabel", to: :display_label
          map_attribute "lang", to: :lang
          map_attribute "script", to: :script
          map_attribute "transliteration", to: :transliteration
          map_attribute "type", to: :type
          map_attribute "altRepGroup", to: :alt_rep_group
          map_attribute "altFormat", to: :alt_format
          map_attribute "contentType", to: :content_type
        end
      end
    end
  end
end
