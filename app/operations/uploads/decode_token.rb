# frozen_string_literal: true

module Uploads
  # Decodes an upload token created with {Uploads::EncodeToken}.
  class DecodeToken
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[decode: "tokens.decode"]

    # @param [String] env the request environment
    # @return [Dry::Monads::Success]
    # @return [Dry::Monads::Failure(Symbol, String)]
    def call(raw_token)
      decode.call raw_token, aud: "upload"
    end
  end
end
