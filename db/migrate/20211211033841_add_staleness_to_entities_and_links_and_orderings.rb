class AddStalenessToEntitiesAndLinksAndOrderings < ActiveRecord::Migration[6.1]
  TABLES = %i[entities orderings].freeze

  def change
    TABLES.each do |table|
      change_table table do |t|
        t.timestamp :stale_at
        t.timestamp :refreshed_at
      end

      reversible do |dir|
        dir.up do
          say_with_time "Populating initial refreshed_at" do
            execute(<<~SQL).cmdtuples
            UPDATE #{table} SET refreshed_at = updated_at
            SQL
          end

          say_with_time "Adding generated stale column" do
            execute(<<~SQL)
            ALTER TABLE #{table}
              ADD COLUMN stale boolean NOT NULL GENERATED ALWAYS AS (stale_at IS NOT NULL AND (refreshed_at IS NULL OR refreshed_at < stale_at)) STORED
            SQL
          end
        end

        dir.down do
          remove_column table, :stale
        end
      end

      change_table table do |t|
        t.index :stale, name: "index_#{table}_staleness"
      end
    end
  end
end
