# frozen_string_literal: true

module Harvesting
  module Extraction
    module Constants
      # Mappers cannot assign to these names as they are
      # reserved for current or future use.
      RESERVED_ASSIGNS = %w[
        meru
        system
        xml
        json
        data
        source
        attempt
        mapping
        record
        entity
        jats
        oaidc
        mets
        mods
        premis
        esploro
      ].freeze
    end
  end
end
