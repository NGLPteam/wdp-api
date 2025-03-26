# frozen_string_literal: true

module Metadata
  module MODS
    module Elements
      class RecordIdentifier < ::Metadata::MODS::Common::AbstractMapper
        attribute :content, :string
        attribute :source, :string

        xml do
          root "recordIdentifier"

          namespace "http://www.loc.gov/mods/v3", "mods"

          map_content to: :content
          map_attribute "source", to: :source
        end
      end
    end
  end
end
