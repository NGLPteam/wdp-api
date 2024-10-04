# frozen_string_literal: true

module Assets
  class EncodeDownloadToken
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[
      encode: "tokens.encode",
    ]

    # @param [Asset] asset
    # @return [Dry::Monads::Success(String)]
    def call(asset, expires_at: 1.day.from_now)
      payload = { aud: "download", sub: asset.id }

      payload[:exp] = expires_at.to_i

      encode.(payload)
    end
  end
end
