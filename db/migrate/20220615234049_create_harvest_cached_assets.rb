class CreateHarvestCachedAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_cached_assets, id: :uuid do |t|
      t.citext :url, null: false
      t.column :fetched_at, :timestamptz, null: true
      t.column :touched_at, :timestamptz, null: true
      t.bigint :file_size

      t.citext :file_name
      t.citext :content_type
      t.citext :signature

      t.jsonb :asset_data
      t.jsonb :metadata, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :url, unique: true
    end
  end
end
