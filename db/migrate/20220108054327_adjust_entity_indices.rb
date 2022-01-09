# frozen_string_literal: true

class AdjustEntityIndices < ActiveRecord::Migration[6.1]
  def change
    remove_index :entities, :auth_path, name: "index_entities_on_auth_path_btree"
    remove_index :entities, :auth_path, name: "index_entities_on_auth_path", using: :gist

    add_index :entities, :auth_path, name: "index_entities_on_auth_path", using: :gist, opclass: "gist_ltree_ops(siglen=1024)"
    add_index :entities, :auth_path, name: "index_entities_on_auth_path_uniqueness", using: :btree, unique: true
  end
end
