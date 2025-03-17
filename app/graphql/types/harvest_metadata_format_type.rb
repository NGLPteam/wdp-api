# frozen_string_literal: true

module Types
  class HarvestMetadataFormatType < Types::BaseEnum
    description <<~TEXT
    Supported metadata formats for harvesting.

    `HarvestProtocol` describes the transport method for individual records to be harvested,
    while `HarvestMetadataFormat` describes the structure of the data.
    TEXT

    value "ESPLORO", value: "esploro" do
      description <<~TEXT
      [Esploro Records](https://developers.exlibrisgroup.com/esploro/apis/xsd/esploro_record.xsd/)
      TEXT
    end

    value "JATS", value: "jats" do
      description <<~TEXT
      [Journal Article Tag Suite](https://jats.nlm.nih.gov/)
      TEXT
    end

    value "METS", value: "mets" do
      description <<~TEXT
      [Metadata Encoding and Transmission Standard](https://www.loc.gov/standards/mets/)
      TEXT
    end

    value "MODS", value: "mods" do
      description <<~TEXT
      [Metadata Object Description Schema](https://www.loc.gov/standards/mods/)
      TEXT
    end

    value "OAIDC", value: "oaidc" do
      description <<~TEXT
      [OAI-PMH Dublin Core](https://www.openarchives.org/OAI/2.0/openarchivesprotocol.htm#dublincore)
      TEXT
    end
  end
end
