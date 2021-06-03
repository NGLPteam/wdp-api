class AddAuthPathToCollectionsAndItems < ActiveRecord::Migration[6.1]
  def change
    change_table :collections do |t|
      t.ltree :auth_path

      t.index :auth_path, using: :gist
    end

    change_table :items do |t|
      t.ltree :auth_path

      t.index :auth_path, using: :gist
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        UPDATE collections c SET auth_path = ca.auth_path
        FROM collection_authorizations ca WHERE ca.collection_id = c.id
        SQL

        execute(<<~SQL.strip_heredoc.squish)
        UPDATE items c SET auth_path = ca.auth_path
        FROM item_authorizations ca WHERE ca.item_id = c.id
        SQL
      end
    end

    change_column_null :collections, :auth_path, false
    change_column_null :items, :auth_path, false
  end
end
