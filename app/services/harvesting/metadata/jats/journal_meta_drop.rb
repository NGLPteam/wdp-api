# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class JournalMetaDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include HasContribGroup

        after_initialize :extract_drops!

        private

        # @return [void]
        def extract_drops!
          @journal_id = @data.journal_id.map do |journal_id|
            subdrop JournalIdDrop, journal_id
          end
        end
      end
    end
  end
end
