# frozen_string_literal: true

module Harvesting
  module Dispatch
    # Accept some kind of object and create a middleware state context from it.
    #
    # It is consumed by other middleware builder functions and ultimately used
    # by {Harvesting::Middleware::Wrap} in order to set up the dry-effects resolution stack.
    class BuildMiddlewareState
      include Dry::Monads[:result]
      include WDPAPI::Deps[
        from_harvest_attempt: "harvesting.middleware.builders.from_harvest_attempt",
        from_harvest_record: "harvesting.middleware.builders.from_harvest_record",
        from_harvest_source: "harvesting.middleware.builders.from_harvest_source",
      ]

      # @param [ApplicationRecord] origin
      # @return [Dry::Monads::Success({ Symbol => Object })]
      # @return [Dry::Monads::Failure(Symbol, String)]
      def call(origin)
        case origin
        when HarvestAttempt
          from_harvest_attempt.call(origin)
        when HarvestEntity
          # HarvestEntity middleware defers to its parent record
          from_harvest_record.call origin.harvest_record
        when HarvestRecord
          from_harvest_record.call(origin)
        when HarvestSource
          from_harvest_source.call(origin)
        else
          Failure[:unknown_origin, "Cannot build middleware state from #{origin.inspect}"]
        end
      end
    end
  end
end
