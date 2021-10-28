# frozen_string_literal: true

module Harvesting
  module Protocols
    class OAI < BaseProtocol
      include WDPAPI::Deps[
        augment_middleware: "harvesting.oai.augment_middleware",
        extract_raw_metadata: "harvesting.oai.extract_raw_metadata",
        extract_records: "harvesting.oai.extract_records",
        extract_sets: "harvesting.oai.extract_sets",
      ]

      protocol_name "OAI-PMH"
    end
  end
end
