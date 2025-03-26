# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class LanguageTerm < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :authority_uri, :string
        attribute :value_uri, :string
        attribute :authority, :string
        attribute :type, :string

        xml do
          root "languageTerm"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "authorityURI", to: :authority_uri
          map_attribute "valueURI", to: :value_uri
          map_attribute "authority", to: :authority
          map_attribute "type", to: :type
        end
      end
    end
  end
end
