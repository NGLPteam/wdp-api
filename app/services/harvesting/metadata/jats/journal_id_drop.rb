# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class JournalIdDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent

        after_initialize :extract_props!

        # @return [String]
        attr_reader :journal_id_type

        private

        # @return [void]
        def extract_props!
          @journal_id_type = @data.journal_id_type
        end
      end
    end
  end
end
