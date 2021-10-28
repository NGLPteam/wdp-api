# frozen_string_literal: true

module Harvesting
  module Protocols
    module Actions
      # @abstract
      class AugmentMiddleware
        include Dry::Monads[:do, :result]

        # @param [{ Symbol => Object }] state
        # @return [Dry::Monads::Result]
        def call(state)
          Success state
        end
      end
    end
  end
end
