# frozen_string_literal: true

module Tokens
  # Encode a JWT with our local security salt.
  #
  # @see Tokens::Decode
  # @operation
  class Encode
    include Dry::Monads[:result]

    # @param [{ Symbol => Object }] payload
    # @return [Dry::Monads::Success(String)] the encoded token
    def call(payload)
      jwk = SecurityConfig.jwk

      headers = { kid: jwk.kid }

      Success JWT.encode payload, jwk.keypair, "RS512", headers
    end
  end
end
