# frozen_string_literal: true

module Assets
  class GenerateDownloadURL
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      encode_download_token: "assets.encode_download_token",
      routes: "system.routes"
    ]

    # @param [Asset]
    # @return [Dry::Monads::Success(String)]
    def call(asset, **options)
      token = yield encode_download_token.(asset, **options)

      Success routes.download_url(asset.system_slug, token: token)
    end
  end
end
