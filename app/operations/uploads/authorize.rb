# frozen_string_literal: true

module Uploads
  # A service that authorizes rack requests for upload access.
  # It allows a variable number of headers to be provided, for
  # use with Uppy/tus.js, direct Authorization access, and for
  # testing with system-granted tokens.
  class Authorize
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[decode_upload_token: "uploads.decode_token"]

    TOKEN_HEADERS = %w[HTTP_UPPY_AUTH_TOKEN].freeze

    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Result]
    def call(env)
      try_keycloak(env).or do
        try_upload_tokens env
      end.or do
        Failure[:unauthorized, "No access to upload"]
      end
    end

    def try_keycloak(env)
      return Failure[:unavailable, "No keycloak auth available"] unless env["keycloak:session"].respond_to?(:authenticate!)

      env["keycloak:session"].authenticate! do |m|
        m.success(:authenticated) do |_, token|
          Success[:keycloak, token]
        end

        m.success do
          Failure[:anonymous]
        end

        m.failure do
          Failure[:other]
        end
      end
    end

    def try_upload_tokens(env)
      start = Failure()

      TOKEN_HEADERS.reduce start do |result, header|
        result.or do
          try_upload_token(env, header)
        end
      end
    end

    def try_upload_token(env, header)
      token = env[header]

      return Failure[:unavailable, "Header #{header.inspect} unavailable"] if token.blank?

      payload = yield decode_upload_token.call token

      Success[:upload_token, payload]
    end
  end
end
