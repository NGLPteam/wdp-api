# frozen_string_literal: true

module Access
  class Revoke
    include Dry::Monads[:result, :do]

    # @param [Role] role
    # @param [Accessible] on
    # @param [AccessGrantSubject] to
    # @return [Dry::Monads::Result]
    def call(role, on:, to:)
      return Success(nil) unless AccessGrant.has_granted?(role, on:, to:)

      grant = AccessGrant.fetch(on, to)

      grant.destroy!

      Success nil
    end
  end
end
