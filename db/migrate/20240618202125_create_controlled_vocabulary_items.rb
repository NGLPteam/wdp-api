class CreateControlledVocabularyItems < ActiveRecord::Migration[7.0]
  def change
    create_table :controlled_vocabulary_items, id: :uuid do |t|
      t.references :controlled_vocabulary, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.references :parent, null: true, foreign_key: { to_table: :controlled_vocabulary_items, on_delete: :cascade }, type: :uuid
      t.bigint :position
      t.text :identifier, null: false
      t.text :label, null: false
      t.text :description
      t.text :url
      t.boolean :unselectable, null: false, default: false

      t.timestamps

      t.index %i[controlled_vocabulary_id identifier], unique: true, name: "index_controlled_vocabulary_items_uniqueness"
    end
  end
end
