class AddContributionCountsToContributors < ActiveRecord::Migration[6.1]
  def change
    change_table :contributors do |t|
      t.bigint :collection_contribution_count, null: false, default: 0
      t.bigint :item_contribution_count, null: false, default: 0
    end

    reversible do |dir|
      dir.up do
        say_with_time "Adding generated contribution_count column" do
          execute(<<~SQL)
          ALTER TABLE contributors ADD COLUMN
            contribution_count bigint GENERATED ALWAYS AS (GREATEST(collection_contribution_count, 0) + GREATEST(item_contribution_count, 0)) STORED;
          SQL
        end

        add_index :contributors, :contribution_count

        say_with_time "Populating contributor collection_contribution_count" do
          execute(<<~SQL).cmdtuples
          WITH contribution_counts AS (
            SELECT contributor_id, COUNT(*) AS contribution_count
            FROM collection_contributions
            GROUP BY 1
          )
          UPDATE contributors SET collection_contribution_count = cc.contribution_count
          FROM contribution_counts cc WHERE cc.contributor_id = contributors.id;
          SQL
        end

        say_with_time "Populating contributor item_contribution_count" do
          execute(<<~SQL).cmdtuples
          WITH contribution_counts AS (
            SELECT contributor_id, COUNT(*) AS contribution_count
            FROM item_contributions
            GROUP BY 1
          )
          UPDATE contributors SET item_contribution_count = cc.contribution_count
          FROM contribution_counts cc WHERE cc.contributor_id = contributors.id;
          SQL
        end
      end

      dir.down do
        remove_column :contributors, :contribution_count
      end
    end
  end
end
