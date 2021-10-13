class CreateHarvestRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_records, id: :uuid do |t|
      t.references :harvest_attempt, null: false, type: :uuid, foreign_key: { on_delete: :cascade }

      t.text :identifier, null: false
      t.text :metadata_format, null: false
      t.text :raw_source
      t.text :raw_metadata_source
      t.jsonb :local_metadata, null: false, default: {}

      t.bigint :entity_count
      t.date :datestamp
      t.date :issued_on
      t.date :available_on
      t.timestamp :issued_at
      t.timestamp :available_at

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_attempt_id identifier], unique: true, name: "index_harvest_records_uniqueness"
    end
  end
end
