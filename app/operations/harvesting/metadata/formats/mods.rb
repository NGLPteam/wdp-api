# frozen_string_literal: true

module Harvesting
  module Metadata
    module Formats
      class MODS < Harvesting::Metadata::BaseFormat
        include WDPAPI::Deps[
          extract_entities: "harvesting.metadata.mods.extract_entities"
        ]
      end
    end
  end
end
