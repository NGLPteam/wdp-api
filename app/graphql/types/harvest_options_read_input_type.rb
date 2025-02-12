# frozen_string_literal: true

module Types
  # @see Harvesting::Options::Read
  # @see Types::HarvestOptionsReadType
  class HarvestOptionsReadInputType < Types::HashInputObject
    description <<~TEXT
    Options that control reading from the source.
    TEXT

    argument :max_records, Integer, required: false, default_value: Harvesting::ABSOLUTE_MAX_RECORD_COUNT, replace_null_with_default: true do
      description <<~TEXT
      The maximum number of records to read from the source per attempt.

      The system will not paginate beyond this count.
      TEXT
    end
  end
end
