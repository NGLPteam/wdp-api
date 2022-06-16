# frozen_string_literal: true

module Harvesting
  module Entities
    # Accepts an {Attachable entity} and a {Harvesting::Assets::ExtractedSource source}
    # in the form of a remote URL, fetches it via {Harvesting::CachedAssets::Fetch the asset cache},
    # and produces an asset with the cached attachment.
    class AttachAsset
      include MonadicPersistence
      include Dry::Effects.Resolve(:harvest_entity)
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        fetch_cached_asset: "harvesting.cached_assets.fetch",
        add_reference: "harvesting.cached_assets.reference",
      ]

      DOWNLOAD_OVERRIDE = %r!(?<=/article/)view(?=/[^/]+/[^/]+)!.freeze

      # @param [Attachable] entity
      # @param [Harvesting::Assets::ExtractedSource]
      # @return [Dry::Monads::Result]
      def call(entity, source)
        asset = entity.assets.by_identifier(source.identifier).first_or_initialize

        metadata = source.to_metadata

        asset.name ||= source.name.presence || source.identifier

        url = prepare_url source.url

        cached = yield fetch_cached_asset.(url)

        found = yield maybe_attach! cached, asset, metadata

        yield add_reference.(cached, asset) if found
        yield add_reference.(cached, harvest_entity)

        entity.assets.reload

        Success found ? asset : nil
      end

      private

      def prepare_url(url)
        url.sub(DOWNLOAD_OVERRIDE, "download")
      end

      # @param [HarvestCachedAsset] cached
      # @param [Asset] asset
      def maybe_attach!(cached, asset, metadata)
        # Skip because signatures match
        return Success() if asset.has_attachment? && cached.signature == asset.signature

        if cached.has_asset?
          cached.asset.download do |io|
            asset.attachment_attacher.assign io, metadata: metadata

            monadic_save asset
          end
        else
          unless asset.has_attachment?
            harvest_entity.log_harvest_error! :asset_not_found, "Cannot retrieve #{cached.url}", url: cached.url

            asset.mark_for_destruction
          end

          Success false
        end
      end
    end
  end
end
