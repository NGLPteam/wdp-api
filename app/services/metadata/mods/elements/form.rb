# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Form < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :type, :string
        attribute :authority, :string

        xml do
          root "form"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "type", to: :type
          map_attribute "authority", to: :authority
        end
      end
    end
  end
end
