# frozen_string_literal: true

# A reference between a {HarvestCachedAsset} and a {ReferencesCachedAssets} model on `cacheable`.
class HarvestCachedAssetReference < ApplicationRecord
  belongs_to :harvest_cached_asset, inverse_of: :harvest_cached_asset_references
  belongs_to :cacheable, polymorphic: true
end
