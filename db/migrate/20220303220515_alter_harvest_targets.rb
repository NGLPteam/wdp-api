class AlterHarvestTargets < ActiveRecord::Migration[6.1]
  def change
    update_targets_for! :harvest_attempts
    update_targets_for! :harvest_mappings
  end

  def update_targets_for!(table)
    change_column_null table, :collection_id, true

    change_table table do |t|
      t.references :target_entity, polymorphic: true, type: :uuid
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN target_entity_type SET DATA TYPE text;
        SQL

        say_with_time "Migrating collections to target_entities for #{table}" do
          execute(<<~SQL).cmdtuples
          UPDATE #{table} SET target_entity_id = collection_id, target_entity_type = 'Collection';
          SQL
        end
      end
    end

    change_column_null table, :target_entity_id, false
    change_column_null table, :target_entity_type, false
  end
end
