class AddPristineToOrderings < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def change
    change_table :orderings do |t|
      t.boolean :pristine, null: false, default: false
    end

    change_table :entities do |t|
      t.index %i[entity_id entity_type schema_version_id], unique: true, name: "index_entities_real", where: %[link_operator IS NULL]
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION jsonb_to_text_array(jsonb) RETURNS text[] AS $$
        SELECT array_agg(x.elm ORDER BY x.idx)
        FROM jsonb_array_elements_text($1) WITH ORDINALITY AS x(elm, idx)
        WHERE jsonb_typeof($1) = 'array';
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL

        execute <<~SQL
        CREATE FUNCTION to_header(schema_versions) RETURNS jsonb AS $$
        SELECT jsonb_build_object('id', $1.id, 'namespace', $1.namespace, 'identifier', $1.identifier, 'version', $1.number);
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL

        execute <<~SQL
        CREATE STATISTICS orderings_id_stats ON entity_id, entity_type, identifier FROM orderings;
        SQL

        execute <<~SQL
        CREATE STATISTICS entities_real_stats ON entity_id, entity_type, system_slug, auth_path, scope FROM entities;
        SQL

        execute <<~SQL
        ALTER TABLE schema_versions
          ADD COLUMN ordering_identifiers text[] GENERATED ALWAYS AS (jsonb_to_text_array(jsonb_path_query_array(configuration, '$.orderings[*].id'))) STORED
        ;
        SQL

        execute <<~SQL
        ALTER TABLE orderings
          ADD COLUMN paths text[] GENERATED ALWAYS AS (jsonb_to_text_array(jsonb_path_query_array(definition, '$.order[*].path'))) STORED
        ;
        SQL

        say_with_time "Setting existing inherited schemas to pristine" do
          execute(<<~SQL).cmdtuples
          UPDATE orderings SET pristine = true WHERE inherited_from_schema;
          SQL
        end
      end

      dir.down do
        remove_column :orderings, :paths
        remove_column :schema_versions, :ordering_identifiers

        execute <<~SQL
        DROP STATISTICS entities_real_stats;
        DROP STATISTICS orderings_id_stats;
        DROP FUNCTION to_header(schema_versions);
        DROP FUNCTION jsonb_to_text_array(jsonb);
        SQL
      end
    end
  end
end
