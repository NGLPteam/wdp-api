# frozen_string_literal: true

class CreateEntityDerivedLayoutDefinitions < ActiveRecord::Migration[7.0]
  def change
    create_table :entity_derived_layout_definitions, id: :uuid do |t|
      t.references :schema_version, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :entity, polymorphic: true, null: false, type: :uuid
      t.references :layout_definition, polymorphic: true, null: false, type: :uuid

      t.enum :layout_kind, enum_type: "layout_kind", null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[entity_id layout_kind], unique: true, name: "udx_entity_derived_layout_definitions_uniqueness"
      t.index %i[layout_definition_type layout_definition_id entity_type entity_id layout_kind], name: "index_edld_check"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE entity_derived_layout_definitions
          ADD CONSTRAINT edld_fk_entities
          FOREIGN KEY ("entity_type", "entity_id")
          REFERENCES "entities" ("entity_type", "entity_id")
          ON DELETE CASCADE
          DEFERRABLE
          INITIALLY DEFERRED
        SQL

        execute <<~SQL
        ALTER TABLE entity_derived_layout_definitions
          ADD CONSTRAINT edld_fk_ldh
          FOREIGN KEY ("layout_definition_type", "layout_definition_id")
          REFERENCES "layout_definition_hierarchies" ("layout_definition_type", "layout_definition_id")
          ON DELETE CASCADE
          DEFERRABLE
          INITIALLY DEFERRED
        SQL

        say_with_time "Populating entity_derived_layout_definitions" do
          exec_update(<<~SQL)
          WITH initial_derivations AS (
            SELECT DISTINCT ON (ent.entity_id, ldh.layout_kind)
              ent.schema_version_id,
              ent.entity_type,
              ent.entity_id,
              ldh.layout_definition_type,
              ldh.layout_definition_id,
              ldh.kind AS layout_definition_kind,
              ldh.layout_kind
              FROM entities ent
              INNER JOIN layout_definition_hierarchies ldh USING (schema_version_id)
              WHERE ent.auth_path <@ ldh.auth_path AND ent.real
              ORDER BY ent.entity_id, ldh.layout_kind, ldh.depth DESC
          )
          INSERT INTO entity_derived_layout_definitions (schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, layout_kind)
          SELECT schema_version_id, entity_type, entity_id, layout_definition_type, layout_definition_id, layout_kind FROM initial_derivations;
          SQL
        end
      end
    end
  end
end
