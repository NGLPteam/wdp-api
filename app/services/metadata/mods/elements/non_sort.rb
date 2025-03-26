# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class NonSort < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :space, :string

        xml do
          root "nonSort"
          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "space", to: :space,
                                 namespace: "http://www.w3.org/XML/1998/namespace", prefix: "xml"
        end
      end
    end
  end
end
