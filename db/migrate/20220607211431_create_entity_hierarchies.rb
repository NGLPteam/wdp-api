class CreateEntityHierarchies < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def change
    create_table :entity_hierarchies, id: :uuid do |t|
      t.references :ancestor, type: :uuid, polymorphic: true, null: false
      t.references :descendant, type: :uuid, polymorphic: true, null: false
      t.references :hierarchical, type: :uuid, polymorphic: true, null: false

      t.references :schema_definition, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :schema_version, type: :uuid, null: false, foreign_key: { on_delete: :cascade }

      t.enum :link_operator, enum_type: "link_operator", null: true

      t.ltree :ancestor_scope, null: false
      t.ltree :descendant_scope, null: false

      t.ltree :auth_path, null: false
      t.ltree :ancestor_slug, null: false
      t.ltree :descendant_slug, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[ancestor_id descendant_id], name: "index_entity_hierarchies_uniqueness", unique: true
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc)
        CREATE FUNCTION ltree_generations(ltree, ltree, ltree) RETURNS bigint AS $$
        SELECT nlevel(
          subltree(
            $1,
            index($1, $2),
            index($1, $3, index($1, $2))
          )
        );
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL

        execute(<<~SQL.strip_heredoc)
        ALTER TABLE entity_hierarchies
          ADD COLUMN depth bigint NOT NULL GENERATED ALWAYS AS (nlevel(auth_path)) STORED,
          ADD COLUMN generations bigint NOT NULL GENERATED ALWAYS AS (ltree_generations(auth_path, ancestor_slug, descendant_slug)) STORED
        ;
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc)
        DROP FUNCTION ltree_generations(ltree, ltree, ltree);
        SQL
      end
    end

    change_table :entity_hierarchies do |t|
      t.index %i[ancestor_type ancestor_id schema_definition_id schema_version_id depth], name: "index_entity_hierarchies_ranking",
        where: %[ancestor_id <> descendant_id], order: { depth: :asc }
    end
  end
end
