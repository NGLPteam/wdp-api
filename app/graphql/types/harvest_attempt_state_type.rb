# frozen_string_literal: true

module Types
  # @see HarvestAttempt
  # @see Harvesting::Attempts::StateMachine
  class HarvestAttemptStateType < Types::BaseEnum
    description <<~TEXT
    The state that an attempt is in.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      An attempt that has not yet extracted anything.
      TEXT
    end

    value "SCHEDULED", value: "scheduled" do
      description <<~TEXT
      A scheduled attempt for a specific mapping that has not yet ran.
      TEXT
    end

    value "EXECUTING", value: "executing" do
      description <<~TEXT
      An attempt that is in the process of extracting records.

      A failed extraction may linger in this state.
      TEXT
    end

    value "EXTRACTED", value: "extracted" do
      description <<~TEXT
      An attempt whose entities have all been extracted from the source.
      TEXT
    end

    value "CANCELLED", value: "cancelled" do
      description <<~TEXT
      A scheduled attempt that was cancelled.
      TEXT
    end
  end
end
