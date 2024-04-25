class CreateCollectionLinkedItems < ActiveRecord::Migration[6.1]
  def change
    create_enum "collection_linked_item_operator", %w[contains references]

    create_table :collection_linked_items, id: :uuid do |t|
      t.references :source, null: false, foreign_key: { to_table: :collections, on_delete: :restrict }, type: :uuid
      t.references :target, null: false, foreign_key: { to_table: :items, on_delete: :restrict }, type: :uuid
      t.enum :operator, enum_type: "collection_linked_item_operator", null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[source_id target_id], unique: true, name: "index_collection_linked_items_uniqueness"
    end
  end
end
