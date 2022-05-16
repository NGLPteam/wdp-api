# frozen_string_literal: true

module Harvesting
  module Protocols
    class OAI < BaseProtocol
      include WDPAPI::Deps[
        augment_middleware: "harvesting.oai.augment_middleware",
        extract_raw_metadata: "harvesting.oai.extract_raw_metadata",
        extract_raw_source: "harvesting.oai.extract_raw_source",
        extract_record: "harvesting.oai.extract_record",
        extract_records: "harvesting.oai.extract_records",
        extract_sets: "harvesting.oai.extract_sets",
        process_record: "harvesting.oai.process_record",
        record_identifier: "harvesting.oai.record_identifier",
      ]

      protocol_name "OAI-PMH"
    end
  end
end
