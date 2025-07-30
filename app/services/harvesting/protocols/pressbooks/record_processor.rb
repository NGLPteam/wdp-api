# frozen_string_literal: true

module Harvesting
  module Protocols
    module Pressbooks
      # Transform a single {Metadata::Pressbooks::Books::Record}
      # into a {HarvestRecord} for later consumption.
      class RecordProcessor < Harvesting::Protocols::RecordProcessor
        # @param [HarvestRecord] record
        # @param [Metadata::Pressbooks::Books::Record] pb_record
        # @return [void]
        def adjust_record!(record, pb_record)
          record.source_changed_at = pb_record.book.metadata.last_updated

          Success()
        end
      end
    end
  end
end
