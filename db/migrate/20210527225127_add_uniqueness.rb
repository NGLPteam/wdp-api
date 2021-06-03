class AddUniqueness < ActiveRecord::Migration[6.1]
  def change
    add_index :collections, %i[identifier community_id parent_id], unique: true, name: "index_collections_unique_identifier"
    add_index :items, %i[identifier collection_id parent_id], unique: true, name: "index_items_unique_identifier"
    add_index :roles, :name, unique: true, name: "index_roles_unique_name"
  end
end
