# frozen_string_literal: true

module Harvesting
  module CachedAssets
    # @see HarvestCachedAsset
    # @see HarvestCachedAssetReference
    class Reference
      include Dry::Monads[:do, :result]

      UNIQUE_BY = %i[harvest_cached_asset_id cacheable_id].freeze

      # @param [HarvestCachedAsset] cached
      # @param [ReferencesCachedAssets] cacheable
      def call(cached, cacheable)
        rows = rows_for cached, cacheable

        return Success() if rows.blank?

        HarvestCachedAssetReference.upsert_all(rows, unique_by: UNIQUE_BY)

        Success()
      end

      private

      # @param [HarvestCachedAsset] cached
      # @param [ReferencesCachedAssets] cacheable
      # @return [<{ Symbol => String }>]
      def rows_for(cached, cacheable)
        models = models_for cacheable

        base = { harvest_cached_asset_id: cached.id }

        models.map do |model|
          base.merge(
            cacheable_type: model.model_name.to_s,
            cacheable_id: model.id
          )
        end
      end

      # @return [<ApplicationRecord>]
      def models_for(cacheable, rows: [])
        case cacheable
        when HarvestRecord
          rows << cacheable
          rows << cacheable.harvest_source
        when HarvestEntity
          rows << cacheable

          models_for cacheable.harvest_record, rows:
        when ::Asset
          rows << cacheable
          rows << cacheable.attachable
        else
          rows
        end
      end
    end
  end
end
