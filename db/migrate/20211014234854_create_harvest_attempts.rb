class CreateHarvestAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_attempts, id: :uuid do |t|
      t.references :harvest_source,   foreign_key: { on_delete: :cascade }, type: :uuid, null: false
      t.references :harvest_set,      foreign_key: { on_delete: :cascade }, type: :uuid, null: true
      t.references :harvest_mapping,  foreign_key: { on_delete: :cascade }, type: :uuid, null: true
      t.references :collection,       foreign_key: { on_delete: :cascade }, type: :uuid, null: false

      t.text :kind, null: false
      t.text :description

      t.jsonb :metadata, null: false, default: {}

      t.bigint :record_count

      t.timestamp :began_at
      t.timestamp :ended_at

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
