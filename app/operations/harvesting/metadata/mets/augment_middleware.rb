# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # Attach dissertation & paper {SchemaVersion}s to states.
      class AugmentMiddleware
        include Dry::Monads[:do, :result]

        def call(state)
          state[:schemas] ||= {}

          state[:schemas][:dissertation] = SchemaVersion["nglp:dissertation:1.0.0"]
          state[:schemas][:paper] = SchemaVersion["nglp:paper:1.0.0"]

          Success state
        end
      end
    end
  end
end
