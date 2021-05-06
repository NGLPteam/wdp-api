# frozen_string_literal: true

module Tokens
  class Encode
    include Dry::Monads[:result]

    # @param [{ Symbol => Object }] payload
    # @return [String]
    def call(payload)
      jwk = SecurityConfig.jwk

      headers = { kid: jwk.kid }

      Success JWT.encode payload, jwk.keypair, "RS512", headers
    end
  end
end
