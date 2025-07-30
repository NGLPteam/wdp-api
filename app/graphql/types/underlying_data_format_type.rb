# frozen_string_literal: true

module Types
  class UnderlyingDataFormatType < Types::BaseEnum
    description <<~TEXT
    The underlying data format for a `HarvestMetadataFormat`.
    TEXT

    value "XML", value: "xml" do
      description <<~TEXT
      The metadata is encoded as XML.
      TEXT
    end

    value "JSON", value: "json" do
      description <<~TEXT
      The metadata is encoded as JSON.
      TEXT
    end
  end
end
