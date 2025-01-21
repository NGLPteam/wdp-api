# frozen_string_literal: true

class ControlContributions < ActiveRecord::Migration[7.0]
  TABLE_PAIRS = {
    collection_contributions: :collection,
    item_contributions: :item,
  }.freeze

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        DROP INDEX IF EXISTS index_item_contributions_uniqueness;
        DROP INDEX IF EXISTS index_collection_contributions_uniqueness;
        SQL
      end
    end

    TABLE_PAIRS.each do |table_name, prefix|
      change_table table_name do |t|
        t.references :role, type: :uuid, null: true, foreign_key: { to_table: :controlled_vocabulary_items, on_delete: :restrict }

        t.bigint :position

        t.index %I[contributor_id #{prefix}_id role_id], name: "index_#{table_name}_assigned_uniqueness", unique: true
      end

      reversible do |dir|
        dir.up do
          say_with_time "Migrating contribution roles by tags" do
            exec_update(<<~SQL)
            WITH vocab AS (
              SELECT controlled_vocabulary_id FROM contribution_role_configurations WHERE source_type = 'GlobalConfiguration' LIMIT 1
            ), roles AS (
              SELECT DISTINCT kind::citext AS role FROM #{table_name} WHERE kind IS NOT NULL AND kind ~ '[^[:space:]]+'
            ), items AS (
              SELECT DISTINCT ON (role)
                role,
                cvi.id AS role_id
                FROM roles
                CROSS JOIN vocab
                INNER JOIN controlled_vocabulary_items cvi USING (controlled_vocabulary_id)
                WHERE role = ANY(cvi.tags)
            )
            UPDATE #{table_name} AS c SET role_id = items.role_id
            FROM items WHERE c.kind = items.role
            SQL
          end

          say_with_time "Filling in default contribution role for other contributions" do
            exec_update(<<~SQL)
            WITH default_item AS (
              SELECT default_item_id AS role_id FROM contribution_role_configurations WHERE source_type = 'GlobalConfiguration' LIMIT 1
            )
            UPDATE #{table_name} AS c SET role_id = default_item.role_id
            FROM default_item WHERE c.role_id IS NULL
            SQL
          end
        end
      end

      change_column_null table_name, :role_id, false
    end
  end
end
