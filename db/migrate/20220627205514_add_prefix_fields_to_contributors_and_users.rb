class AddPrefixFieldsToContributorsAndUsers < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE contributors
          ADD COLUMN search_name text GENERATED ALWAYS AS (to_prefix_search(derive_contributor_name(kind, properties))) STORED
        ;

        ALTER TABLE users
          ADD COLUMN search_given_name text NOT NULL GENERATED ALWAYS AS (to_prefix_search(given_name)) STORED,
          ADD COLUMN search_family_name text NOT NULL GENERATED ALWAYS AS (to_prefix_search(family_name)) STORED
        ;
        SQL
      end

      dir.down do
        remove_column :contributors, :search_name
        remove_column :users, :search_given_name
        remove_column :users, :search_family_name
      end
    end

    change_table :contributors do |t|
      t.index %i[search_name], using: :gin, opclass: "gin_trgm_ops", name: "index_contributors_prefix_searching_names"
    end

    change_table :users do |t|
      t.index %i[search_given_name search_family_name], using: :gin, opclass: "gin_trgm_ops", name: "index_users_prefix_searching_names"
    end
  end
end
