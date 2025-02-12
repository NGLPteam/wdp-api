# frozen_string_literal: true

module Types
  class HarvestProtocolType < Types::BaseEnum
    description <<~TEXT
    Protocols for harvesting. Only `OAI` is presently supported.

    `HarvestProtocol` describes the transport method for individual records to be harvested,
    while `HarvestMetadataFormat` describes the structure of the data.
    TEXT

    value "OAI", value: "oai" do
      description <<~TEXT
      [OAI-PMH](https://www.openarchives.org/OAI/2.0/guidelines.htm)
      TEXT
    end
  end
end
