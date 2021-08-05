class CreateOrderings < ActiveRecord::Migration[6.1]
  def change
    create_table :orderings, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :schema_version, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :community, type: :uuid, null: true, foreign_key: { on_delete: :cascade }
      t.references :collection, type: :uuid, null: true, foreign_key: { on_delete: :cascade }
      t.references :item, type: :uuid, null: true, foreign_key: { on_delete: :cascade }

      t.citext :identifier, null: false

      t.boolean :inherited_from_schema, null: false, default: false

      t.jsonb :definition, null: false, default: {}

      t.timestamp :disabled_at
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_id entity_type identifier], unique: true, name: "index_orderings_uniqueness"
      t.index %i[entity_id entity_type], where: %[disabled_at IS NULL], name: "index_orderings_enabled_by_entity"
    end
  end
end
