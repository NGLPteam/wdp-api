class CreateCollectionHierarchies < ActiveRecord::Migration[6.1]
  def change
    create_table :collection_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :collection_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "collection_anc_desc_idx"

    add_index :collection_hierarchies, [:descendant_id],
      name: "collection_desc_idx"
  end
end
