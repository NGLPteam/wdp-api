class AddExistingParentToHarvestEntities < ActiveRecord::Migration[6.1]
  def change
    change_table :harvest_entities do |t|
      t.references :existing_parent, null: true, type: :uuid, polymorphic: true

      t.jsonb :extracted_links

      t.check_constraint <<~SQL.strip_heredoc.squish, name: "harvest_entity_exclusive_parentage"
      CASE WHEN existing_parent_id IS NOT NULL THEN parent_id IS NULL WHEN parent_id IS NOT NULL THEN existing_parent_id IS NULL ELSE parent_id IS NULL AND existing_parent_id IS NULL END
      SQL
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE harvest_entities ALTER COLUMN existing_parent_type SET DATA TYPE text;
        SQL
      end
    end
  end
end
