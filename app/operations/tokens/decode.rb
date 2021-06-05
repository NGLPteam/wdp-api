# frozen_string_literal: true

module Tokens
  class Decode
    include Dry::Monads[:result]

    # @param [String] token
    # @return [Hash]
    def call(token, aud: nil, sub: nil)
      return Failure[:no_token_provided, "No token provided"] if token.blank?

      jwk = SecurityConfig.jwk

      jwks = { keys: [jwk.export] }

      decode_headers = { algorithms: ["RS512"], jwks: jwks }

      if aud.present?
        decode_headers[:aud] = aud
        decode_headers[:verify_aud] = true
      end

      if sub.present?
        decode_headers[:sub] = sub
        decode_headers[:verify_sub] = true
      end

      payload, _headers = JWT.decode token, nil, true, decode_headers

      Success payload
    rescue JWT::JWKError => e
      Failure[:invalid_jwk, e.message]
    rescue JWT::DecodeError => e
      Failure[:invalid_token, e.message]
    end
  end
end
