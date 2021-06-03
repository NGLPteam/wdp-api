# frozen_string_literal: true

module Access
  class Grant
    include Dry::Monads[:result, :do]

    # @param [Role] role
    # @param [Accessible] on
    # @param [User] to
    # @return [Dry::Monads::Result]
    def call(role, on:, to:)
      return Success(nil) if AccessGrant.has_granted?(role, on: on, to: to)

      grant = AccessGrant.fetch(on, to)

      grant.role = role

      grant.save!

      Success nil
    end
  end
end
