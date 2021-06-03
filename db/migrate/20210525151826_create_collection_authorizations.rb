class CreateCollectionAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_view :collection_authorizations, materialized: true

    add_index :collection_authorizations, :collection_id, unique: true
    add_index :collection_authorizations, :community_id
    add_index :collection_authorizations, :auth_path, using: :gist
  end
end
