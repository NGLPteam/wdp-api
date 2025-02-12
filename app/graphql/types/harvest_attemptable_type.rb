# frozen_string_literal: true

module Types
  module HarvestAttemptableType
    include Types::BaseInterface

    description <<~TEXT
    A record that can be used to trigger a run of the harvesting
    subsystem via `harvestStart`.
    TEXT

    field :harvest_attempts, resolver: ::Resolvers::HarvestAttemptResolver do
      description <<~TEXT
      Harvest attempts associated with this record.
      TEXT
    end
  end
end
