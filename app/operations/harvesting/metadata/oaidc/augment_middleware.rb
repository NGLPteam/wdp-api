# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # Attach schemas used for OAIDC to the state.
      class AugmentMiddleware
        include Dry::Monads[:result]

        def call(state)
          state[:schemas] ||= {}

          state[:schemas][:volume] = SchemaVersion["nglp:journal_volume:1.0.0"]
          state[:schemas][:issue] = SchemaVersion["nglp:journal_issue:1.0.0"]
          state[:schemas][:article] = SchemaVersion["nglp:journal_article:1.0.0"]
          state[:schemas][:dissertation] = SchemaVersion["nglp:dissertation:1.0.0"]
          state[:schemas][:paper] = SchemaVersion["nglp:paper:1.0.0"]

          Success state
        end
      end
    end
  end
end
