class AddAuthPathToCommunities < ActiveRecord::Migration[6.1]
  def change
    change_table :communities do |t|
      t.ltree :auth_path

      t.index :auth_path, using: :gist
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.squish)
        UPDATE communities SET auth_path = text2ltree(system_slug);
        SQL
      end
    end

    change_column_null :communities, :auth_path, false
  end
end
