# frozen_string_literal: true

module Types
  module HasHarvestMetadataFormatType
    include Types::BaseInterface

    description <<~TEXT
    A record that stores a metadata format it uses.
    TEXT

    field :metadata_format, Types::HarvestMetadataFormatType, null: false do
      description <<~TEXT
      The metadata format used by this source / mapping.

      Fixed at creation time for now.
      TEXT
    end
  end
end
