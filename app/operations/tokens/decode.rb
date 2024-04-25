# frozen_string_literal: true

module Tokens
  # Decode a JWT that relies on our local security salt.
  #
  # @see Tokens::Encode
  # @operation
  class Decode
    include Dry::Monads[:result]

    # @param [String] token
    # @param [String, nil] aud
    # @param [String, nil] sub
    # @return [Dry::Monads::Success(Hash)] the decoded token payload
    # @return [Dry::Monads::Failure(:invalid_jwk, String)] on an error with signing key
    # @return [Dry::Monads::Failure(:invalid_token, String)] if the token is otherwise invalid
    def call(token, aud: nil, sub: nil)
      return Failure[:no_token_provided, "No token provided"] if token.blank?

      jwk = SecurityConfig.jwk

      jwks = { keys: [jwk.export] }

      decode_headers = { algorithms: ["RS512"], jwks: }

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
      # :nocov:
      Failure[:invalid_jwk, e.message]
      # :nocov:
    rescue JWT::ExpiredSignature => e
      Failure[:expired, e.message]
    rescue JWT::DecodeError => e
      Failure[:invalid_token, e.message]
    end
  end
end
