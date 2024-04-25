# frozen_string_literal: true

module Support
  # An abstract, monadic service that satisfies certain constraints.
  #
  # @api private
  # @see Support::SimpleServiceOperation
  class NullService
    include Dry::Monads[:result]

    # @return [Dry::Monads::Result]
    def call
      Success()
    end
  end
end
