# frozen_string_literal: true

module Metadata
  module MODS
    # @see https://www.loc.gov/standards/mods/userguide/subject.html#cartographicextension
    module Elements
      class CartographicExtension < ::Metadata::MODS::Common::AbstractMapper
        attribute :raw_content, :string
        attribute :display_label, :string

        xml do
          root "cartographicExtension"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_all to: :raw_content

          map_attribute "displayLabel", to: :display_label
        end
      end
    end
  end
end
