# frozen_string_literal: true

module Harvesting
  module Metadata
    module Esploro
      # @see EsploroSchema::Record
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_record!

        after_assigns :build_record_drop!

        # @return [EsploroSchema::Record]
        attr_reader :record

        private

        # @return [void]
        def build_record_drop!
          @assigns[:esploro] = build_drop Harvesting::Metadata::Esploro::RecordDrop, @record
        end

        # @return [void]
        def parse_record!
          @record = EsploroSchema::Record.parse metadata_source
        end
      end
    end
  end
end
