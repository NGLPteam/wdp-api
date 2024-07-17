class CreateControlledVocabularies < ActiveRecord::Migration[7.0]
  def change
    create_table :controlled_vocabularies, id: :uuid do |t|
      t.text :namespace, null: false
      t.text :identifier, null: false
      t.column :version, :semantic_version, null: false
      t.text :provides, null: false

      t.text :name, null: false

      t.text :description

      t.bigint :items_count, null: false, default: 0
      t.text :item_identifiers, null: false, default: [], array: true

      t.jsonb :item_set

      t.timestamps

      t.index %i[namespace identifier version], unique: true, name: "index_controlled_vocabularies_uniqueness"
      t.index %i[provides]
    end
  end
end
