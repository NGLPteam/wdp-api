class NormalizeVersionConfigurations < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze
  TRIG_LANG = "plpgsql".freeze

  def up
    say_with_time "Normalizing schema configurations" do
      execute(<<~SQL).cmdtuples
      UPDATE schema_versions AS sv SET
        configuration = jsonb_build_object('namespace', sd.namespace, 'identifier', sd.identifier, 'kind', sd.kind) || configuration - ARRAY['id', 'consumer']
        FROM schema_definitions AS sd
        WHERE sd.id = sv.schema_definition_id
      ;
      SQL
    end

    say_with_time "Normalizing improperly serialized schema version" do
      execute(<<~SQL).cmdtuples
      UPDATE schema_versions SET configuration = jsonb_set(configuration, ARRAY['version'],
        to_jsonb(
          CONCAT(
            COALESCE(configuration #>> ARRAY['version', 'major'], '0'),
            '.'::text,
            COALESCE(configuration #>> ARRAY['version', 'minor'], '0'),
            '.'::text,
            COALESCE(configuration #>> ARRAY['version', 'patch'], '0'),
            (
              '-' || (configuration #>> ARRAY['version', 'pre'])
            ),
            (
              '+' || (configuration #>> ARRAY['version', 'build'])
            )
          )
        )
      )
      WHERE
        jsonb_typeof(configuration -> 'version') = 'object'
        AND
        configuration -> 'version' ?& ARRAY['major', 'minor', 'patch', 'pre', 'build']
        AND
        jsonb_typeof(configuration #> ARRAY['version', 'major']) = 'number'
        AND
        jsonb_typeof(configuration #> ARRAY['version', 'minor']) = 'number'
        AND
        jsonb_typeof(configuration #> ARRAY['version', 'patch']) = 'number'
        AND
        jsonb_typeof(configuration #> ARRAY['version', 'pre']) IN ('null', 'string')
        AND
        jsonb_typeof(configuration #> ARRAY['version', 'build']) IN ('null', 'string')
      ;
      SQL
    end

    say_with_time "Adding to_schema_kind functions" do
      execute <<~SQL
      CREATE FUNCTION to_schema_kind(text) RETURNS schema_kind AS $$
      SELECT CASE WHEN $1 = ANY(enum_range(NULL::schema_kind)::text[]) THEN $1::schema_kind ELSE NULL END;
      $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
      SQL
    end

    say_with_time "Add check constraint for configured version" do
      execute <<~SQL
      ALTER TABLE schema_versions
        ADD CONSTRAINT configuration_has_name CHECK (configuration ? 'name' AND jsonb_typeof(configuration -> 'name') = 'string'),
        ADD CONSTRAINT configuration_has_namespace CHECK (configuration ? 'namespace' AND jsonb_typeof(configuration -> 'namespace') = 'string'),
        ADD CONSTRAINT configuration_has_identifier CHECK (configuration ? 'identifier' AND jsonb_typeof(configuration -> 'identifier') = 'string'),
        ADD CONSTRAINT configuration_is_valid_kind CHECK (configuration ? 'kind' AND configuration ->> 'kind' = ANY(enum_range(NULL::schema_kind)::text[])),
        ADD CONSTRAINT configured_version_is_semantic CHECK (is_valid_semver(configuration -> 'version'))
      SQL
    end

    remove_existing_number!

    say_with_time "Surfacing configured values" do
      execute <<~SQL
      ALTER TABLE schema_versions
        ADD COLUMN name text NOT NULL GENERATED ALWAYS AS (configuration ->> 'name') STORED,
        ADD COLUMN kind schema_kind NOT NULL GENERATED ALWAYS AS (to_schema_kind(configuration ->> 'kind')) STORED,
        ADD COLUMN number semantic_version NOT NULL GENERATED ALWAYS AS (configuration ->> 'version') STORED,
        ADD COLUMN namespace text NOT NULL GENERATED ALWAYS AS (configuration ->> 'namespace') STORED,
        ADD COLUMN identifier text NOT NULL GENERATED ALWAYS AS (configuration ->> 'identifier') STORED,
        ADD COLUMN declaration text NOT NULL GENERATED ALWAYS AS ((configuration ->> 'namespace') || ':' || (configuration ->> 'identifier') || ':' || (configuration ->> 'version')) STORED;
      SQL
    end

    change_table :schema_versions do |t|
      t.index :kind
      t.index %i[namespace identifier], name: "index_schema_versions_by_tuple"
      t.index %i[declaration], unique: true
    end

    readd_number! with_column: false

    say_with_time "Protecting schema definition FK" do
      execute <<~SQL
      CREATE FUNCTION prevent_column_update() RETURNS TRIGGER AS $$
      DECLARE
        protected_column text := COALESCE(TG_ARGV[0], 'UNKNOWN');
      BEGIN
        RAISE EXCEPTION 'attempted to update protected column %.%', TG_TABLE_NAME, protected_column;
      END;
      $$ LANGUAGE #{TRIG_LANG};

      CREATE TRIGGER lock_version_definition_id
        BEFORE UPDATE OF schema_definition_id
        ON schema_versions
        FOR EACH ROW
        WHEN (OLD.schema_definition_id <> NEW.schema_definition_id)
        EXECUTE FUNCTION prevent_column_update('schema_definition_id');
      SQL
    end
  end

  def down
    say_with_time "Relaxing protections on schema definition FK" do
      execute <<~SQL
      DROP TRIGGER lock_version_definition_id ON schema_versions;
      DROP FUNCTION prevent_column_update();
      SQL
    end

    # Remove generated columns
    remove_column :schema_versions, :kind
    remove_column :schema_versions, :name
    remove_column :schema_versions, :namespace
    remove_column :schema_versions, :identifier
    remove_column :schema_versions, :declaration

    execute <<~SQL
    DROP FUNCTION to_schema_kind(text);
    SQL

    say_with_time "Removing configuration check constraints" do
      execute <<~SQL
      ALTER TABLE schema_versions
        DROP CONSTRAINT configuration_has_name,
        DROP CONSTRAINT configuration_has_namespace,
        DROP CONSTRAINT configuration_has_identifier,
        DROP CONSTRAINT configuration_is_valid_kind,
        DROP CONSTRAINT configured_version_is_semantic
      ;
      SQL
    end

    say_with_time "Denormalizing schema configurations" do
      execute(<<~SQL).cmdtuples
      UPDATE schema_versions AS sv SET
        configuration = jsonb_build_object('id', sd.identifier, 'consumer', sd.kind) || configuration - ARRAY['identifier', 'kind', 'namespace']
        FROM schema_definitions AS sd
        WHERE sd.id = sv.schema_definition_id
      ;
      SQL
    end

    remove_existing_number!

    readd_number! with_column: true

    say_with_time "Repopulating number values" do
      execute(<<~SQL).cmdtuples
      UPDATE schema_versions SET number = configuration ->> 'version';
      SQL
    end

    change_column_null :schema_versions, :number, false
  end

  private

  def remove_existing_number!
    drop_view :ordering_entry_candidates

    remove_column :schema_versions, :parsed

    remove_index :schema_versions, column: %i[schema_definition_id number], name: "index_schema_versions_uniqueness", unique: true

    remove_column :schema_versions, :number
  end

  def readd_number!(with_column: false)
    change_table :schema_versions do |t|
      t.column :number, :semantic_version if with_column

      t.index %i[schema_definition_id number], name: "index_schema_versions_uniqueness", unique: true
    end

    say_with_time "Add back generated parsed column" do
      execute <<~SQL
      ALTER TABLE schema_versions
        ADD COLUMN parsed parsed_semver NOT NULL GENERATED ALWAYS AS (parse_semver(#{with_column ? "number" : %[configuration ->> 'version']})) STORED;
      SQL
    end

    create_view :ordering_entry_candidates, version: 1
  end
end
