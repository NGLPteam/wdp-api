class CreateHarvestEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :harvest_entities, id: :uuid do |t|
      t.references :harvest_record, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :parent, null: true, type: :uuid, foreign_key: { to_table: :harvest_entities, on_delete: :cascade }
      t.references :schema_version, null: true, type: :uuid, foreign_key: { on_delete: :restrict }
      t.references :entity, null: true, type: :uuid, polymorphic: true

      t.text :identifier, null: false
      t.text :metadata_kind

      t.jsonb :extracted_attributes
      t.jsonb :extracted_properties
      t.jsonb :extracted_assets

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[harvest_record_id identifier], unique: true, name: "index_harvest_entities_uniqueness"
    end

    create_table :harvest_entity_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :harvest_entity_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "harvest_entity_anc_desc_idx"

    add_index :harvest_entity_hierarchies, [:descendant_id],
      name: "harvest_entity_desc_idx"
  end
end
