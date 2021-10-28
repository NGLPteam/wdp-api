# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class AugmentMiddleware
        include Dry::Monads[:do, :result]

        def call(state)
          state[:schemas] ||= {}

          state[:schemas][:volume] = SchemaVersion["nglp:journal_volume"]
          state[:schemas][:issue] = SchemaVersion["nglp:journal_issue"]
          state[:schemas][:article] = SchemaVersion["nglp:journal_article"]

          Success state
        end
      end
    end
  end
end
