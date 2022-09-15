# frozen_string_literal: true

module Assets
  class DecodeDownloadToken
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      decode: "tokens.decode",
    ]

    # @param [Asset] asset
    # @param [String] token
    # @return [Dry::Monads::Success(Boolean)]
    def call(asset, token)
      return Failure[:missing_token] if token.blank?

      payload = yield decode.(token, aud: "download", sub: asset.id)

      Success payload.present?
    end
  end
end
