# frozen_string_literal: true

module Harvesting
  module Metadata
    class ModsProcessor < AbstractProcessor
      include WDPAPI::Deps[extract_entities: "harvesting.metadata.extract_mods_entities"]

      def format
        "mods"
      end

      def oai_metadata_prefix
        "mods"
      end
    end
  end
end
