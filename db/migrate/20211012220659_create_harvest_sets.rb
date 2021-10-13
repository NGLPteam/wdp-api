class CreateHarvestSets < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_sets, id: :uuid do |t|
      t.references :harvest_source, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.text :identifier, null: false
      t.text :name, null: false
      t.text :description
      t.text :raw_source

      t.jsonb :metadata, null: false, default: {}

      t.integer :estimated_record_count

      t.timestamp :last_harvested_at, null: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_source_id identifier], unique: true, name: "index_harvest_sets_uniqueness"
    end
  end
end
