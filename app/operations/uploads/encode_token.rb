# frozen_string_literal: true

module Uploads
  # Generate a token that can be provided on the Uppy-Token header,
  # for use with uppy / tus.js clients.
  class EncodeToken
    include Dry::Monads[:result]
    include WDPAPI::Deps[encode: "tokens.encode"]

    # @param [{ String => String }] env the request environment
    def call
      exp = 5.hours.from_now.to_i

      encode.call(aud: "upload", exp: exp)
    end
  end
end
