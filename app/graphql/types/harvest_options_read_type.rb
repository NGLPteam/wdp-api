# frozen_string_literal: true

module Types
  # @see Harvesting::Options::Read
  # @see Types::HarvestOptionsReadInputType
  class HarvestOptionsReadType < Types::BaseObject
    description <<~TEXT
    Options that control reading from the source.
    TEXT

    field :max_records, Integer, null: false do
      description <<~TEXT
      The maximum number of records to read from the source per attempt.

      The system will not paginate beyond this count.
      TEXT
    end
  end
end
