# frozen_string_literal: true

module Harvesting
  module Entities
    # Accepts an {Attachable entity} and a {Harvesting::Assets::ExtractedSource source},
    # in the form of a remote URL, and attaches it as an {Asset} to the entity.
    class AttachAsset
      include MonadicPersistence

      # @param [Attachable] entity
      # @param [Harvesting::Assets::ExtractedSource]
      # @return [Dry::Monads::Result]
      def call(entity, source)
        asset = entity.assets.by_identifier(source.identifier).first_or_initialize

        metadata = source.to_metadata

        asset.name ||= source.name.presence || source.identifier

        asset.attachment_attacher.assign_remote_url(source.url, metadata: metadata)

        monadic_save asset
      end
    end
  end
end
