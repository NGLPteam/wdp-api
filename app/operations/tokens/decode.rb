# frozen_string_literal: true

module Tokens
  class Decode
    include Dry::Monads[:result]

    # @param [String] token
    # @return [String]
    def call(token)
      jwk = SecurityConfig.jwk

      jwks = { keys: [jwk.export] }

      decode_headers = { algorithms: ["RS512"], jwks: jwks }

      payload, _headers = JWT.decode token, nil, true, decode_headers

      Success payload
    rescue JWT::JWKError => e
      Failure[:invalid_jwk, e.message]
    rescue JWT::DecodeError => e
      Failure[:invalid_token, e.message]
    end
  end
end
