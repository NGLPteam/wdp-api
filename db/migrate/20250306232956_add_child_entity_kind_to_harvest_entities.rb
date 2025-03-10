# frozen_string_literal: true

class AddChildEntityKindToHarvestEntities < ActiveRecord::Migration[7.0]
  def change
    change_table :harvest_entities do |t|
      t.enum :entity_kind, enum_type: :child_entity_kind, null: true
    end

    reversible do |dir|
      dir.up do
        say_with_time "Derive collection harvest entities" do
          exec_update(<<~SQL)
          UPDATE harvest_entities SET entity_kind = 'collection'
          WHERE schema_version_id IN (SELECT id FROM schema_versions WHERE kind = 'collection'::schema_kind)
          SQL
        end

        say_with_time "Derive item harvest entities" do
          exec_update(<<~SQL)
          UPDATE harvest_entities SET entity_kind = 'item'
          WHERE schema_version_id IN (SELECT id FROM schema_versions WHERE kind = 'item'::schema_kind)
          SQL
        end

        say_with_time "Possibly prune contributions for un-derivable entities" do
          exec_delete(<<~SQL)
          DELETE FROM harvest_contributions WHERE harvest_entity_id IN (SELECT id FROM harvest_entities WHERE entity_kind IS NULL OR schema_version_id IS NULL);
          SQL
        end

        say_with_time "Prune un-derivable entities (just in case)" do
          exec_delete(<<~SQL)
          DELETE FROM harvest_entities WHERE entity_kind IS NULL OR schema_version_id IS NULL;
          SQL
        end
      end
    end

    change_column_null :harvest_entities, :schema_version_id, false
    change_column_null :harvest_entities, :entity_kind, false
  end
end
