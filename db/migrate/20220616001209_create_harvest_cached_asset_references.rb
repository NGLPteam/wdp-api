class CreateHarvestCachedAssetReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_cached_asset_references, id: :uuid do |t|
      t.references :harvest_cached_asset, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.references :cacheable, polymorphic: true, null: false, type: :uuid, index: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_cached_asset_id cacheable_id], unique: true, name: "index_hcar_uniqueness"
    end
  end
end
