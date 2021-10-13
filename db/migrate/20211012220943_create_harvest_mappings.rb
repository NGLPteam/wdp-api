class CreateHarvestMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_mappings, id: :uuid do |t|
      t.references :harvest_source, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :harvest_set, null: true, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :collection, null: true, foreign_key: { on_delete: :restrict }, type: :uuid

      t.text :mode, null: false, default: "manual"
      t.text :frequency
      t.text :frequency_expression

      t.jsonb :list_options,    null: false, default: {}
      t.jsonb :read_options,    null: false, default: {}
      t.jsonb :format_options,  null: false, default: {}
      t.jsonb :mapping_options, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_source_id harvest_set_id collection_id], unique: true, name: "index_harvest_mappings_uniqueness"
    end
  end
end
