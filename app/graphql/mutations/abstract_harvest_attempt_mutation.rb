# frozen_string_literal: true

module Mutations
  # @abstract
  class AbstractHarvestAttemptMutation < Mutations::BaseMutation
    field :harvest_attempt, Types::HarvestAttemptType, null: true do
      description <<~TEXT
      The newly created harvest attempt record, if successful.
      TEXT
    end

    argument :note, String, required: false do
      description <<~TEXT
      An optional note for this harvesting attempt.
      TEXT
    end
  end
end
