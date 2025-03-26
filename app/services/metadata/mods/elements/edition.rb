# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class Edition < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :supplied, :string

        xml do
          root "edition"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "supplied", to: :supplied
        end
      end
    end
  end
end
