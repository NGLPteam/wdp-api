class RelaxDOIUniquenessConstraintOnEntities < ActiveRecord::Migration[6.1]
  def change
    remove_index :collections, column: :doi, unique: true
    remove_index :items, column: :doi, unique: true

    add_index :collections, :doi
    add_index :items, :doi
  end
end
