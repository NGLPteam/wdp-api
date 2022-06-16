# frozen_string_literal: true

# @see HarvestCachedAsset
# @see HarvestCachedAssetReference
# @see Harvesting::CachedAssets::Reference
module ReferencesCachedAssets
  extend ActiveSupport::Concern

  included do
    has_many :harvest_cached_asset_references, as: :cacheable, dependent: :delete_all

    has_many :harvest_cached_assets, through: :harvest_cached_asset_references
  end
end
