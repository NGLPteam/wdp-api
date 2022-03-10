# frozen_string_literal: true

module Harvesting
  module Protocols
    module Actions
      class ProcessRecordBatch < Harvesting::Protocols::RecordBatchProcessor
        # @param [Object] raw_record
        # @return [Dry::Monads::Success]
        def process(raw_record)
          protocol.process_record.(raw_record)
        end
      end
    end
  end
end
