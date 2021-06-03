class CreateItemAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_view :item_authorizations, materialized: true

    add_index :item_authorizations, :item_id, unique: true
    add_index :item_authorizations, :community_id
    add_index :item_authorizations, :collection_id
    add_index :item_authorizations, :auth_path, using: :gist
  end
end
