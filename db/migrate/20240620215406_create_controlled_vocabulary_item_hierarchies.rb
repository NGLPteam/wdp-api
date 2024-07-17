class CreateControlledVocabularyItemHierarchies < ActiveRecord::Migration[7.0]
  def change
    create_table :controlled_vocabulary_item_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :controlled_vocabulary_item_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "controlled_vocabulary_item_anc_desc_idx"

    add_index :controlled_vocabulary_item_hierarchies, [:descendant_id],
      name: "controlled_vocabulary_item_desc_idx"
  end
end
