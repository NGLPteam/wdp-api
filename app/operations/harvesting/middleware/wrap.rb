# frozen_string_literal: true

module Harvesting
  module Middleware
    # A wrapper class intended to set up a dry-effects resolution context.
    #
    # It takes a model that gets sent to {Harvesting::Dispatch::BuildMiddlewareState}
    # in order to programatically generate a state, and then sets it up with `#provide`
    # for the duration of the block passed to {#call}.
    #
    # It is designed so it can be nested within itself during the harvesting process,
    # such that a {HarvestSource} can set up middleware, and later in the process,
    # so can a {HarvestAttempt}. Any overlapping keys will be overridden for the
    # duration of the attempt's call, and revert to the state that the {HarvestSource} had
    # set once it is over.
    class Wrap
      include Dry::Effects::Handler.Resolve
      include WDPAPI::Deps[
        build_middleware_state: "harvesting.dispatch.build_middleware_state",
      ]

      include Dry::Matcher.for(:build_handler_state_for, with: Dry::Matcher::ResultMatcher)

      # @param [ApplicationRecord] (@see Harvesting::Dispatch::BuildMiddlewareState)
      # @return [void]
      def call(origin)
        build_handler_state_for origin do |m|
          m.success do |handler_state|
            provide handler_state do
              yield if block_given?
            end
          end

          m.failure do |_code, reason|
            # :nocov:
            raise "Could not wrap middleware: #{reason}"
            # :nocov:
          end
        end
      end

      private

      # @return [{ Symbol => Object }]
      def build_handler_state_for(origin)
        build_middleware_state.call(origin)
      end
    end
  end
end
