class AddRoleSupportFunctions < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def change
    create_enum "role_primacy", %w[high default low]
    create_enum "role_kind", %w[system custom]
    create_enum "role_identifier", %w[admin manager editor reader]

    reversible do |dir|
      dir.down do
        execute <<~SQL
        DROP CAST (role_identifier AS role_kind);
        DROP CAST (role_identifier AS role_primacy);
        DROP FUNCTION calculate_role_primacy(role_identifier);
        DROP FUNCTION calculate_role_kind(role_identifier);
        DROP FUNCTION calculate_role_priority(role_identifier, smallint);
        DROP FUNCTION calculate_role_priority(role_identifier);
        DROP FUNCTION calculate_allowed_actions(jsonb);
        DROP FUNCTION calculate_actions(jsonb);
        DROP FUNCTION calculate_action(ltree, jsonb);
        SQL
      end
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION calculate_action(action ltree, value jsonb) RETURNS TABLE (action ltree, allowed boolean) AS $$
        SELECT
          $1 AS action,
          $2 = 'true'::jsonb AS allowed
          WHERE jsonb_typeof($2) = 'boolean';
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

        CREATE FUNCTION calculate_actions(jsonb) RETURNS TABLE(action ltree, allowed boolean) AS $$
        WITH RECURSIVE flattened (scope, value) AS (
          SELECT
            grid.scope::ltree AS scope,
            grid.value AS value
            FROM jsonb_each($1) AS grid(scope, value)
            WHERE jsonb_typeof($1) = 'object'
          UNION ALL
          SELECT
            flattened.scope || COALESCE(grid.scope, '') AS scope,
            grid.value AS value
          FROM
            flattened, jsonb_each(flattened.value) AS grid(scope, value)
          WHERE jsonb_typeof(flattened.value) = 'object'
        ), actions AS (
          SELECT action.action, action.allowed FROM flattened, calculate_action(flattened.scope, flattened.value) AS action(action, allowed) WHERE jsonb_typeof(flattened.value) = 'boolean'
        ) SELECT DISTINCT ON (action) action, allowed FROM actions WHERE action IS NOT NULL;
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

        CREATE FUNCTION calculate_allowed_actions(jsonb) RETURNS ltree[] AS $$
        SELECT COALESCE(
          array_agg(action ORDER BY action) FILTER (WHERE allowed),
          '{}'::ltree[]
        ) FROM calculate_actions($1) AS t(action, allowed)
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

        CREATE FUNCTION calculate_role_kind(role_identifier) RETURNS role_kind AS $$
        SELECT CASE
        WHEN $1 IS NOT NULL THEN 'system'
        ELSE
          'custom'
        END::role_kind;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

        CREATE CAST (role_identifier AS role_kind)
          WITH FUNCTION calculate_role_kind(role_identifier)
          AS ASSIGNMENT;

        CREATE FUNCTION calculate_role_primacy(role_identifier) RETURNS role_primacy AS $$
        SELECT CASE $1
        WHEN 'admin' THEN 'high'
        WHEN 'reader' THEN 'low'
        ELSE
          'default'
        END::role_primacy;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

        CREATE CAST (role_identifier AS role_primacy)
          WITH FUNCTION calculate_role_primacy(role_identifier)
          AS ASSIGNMENT;

        CREATE FUNCTION calculate_role_priority(role_identifier) RETURNS int AS $$
        SELECT CASE $1
        WHEN 'admin' THEN 40000
        WHEN 'manager' THEN 20000
        WHEN 'editor' THEN -20000
        WHEN 'reader' THEN -40000
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

        CREATE FUNCTION calculate_role_priority(role_identifier, smallint) RETURNS int AS $$
        SELECT CASE
        WHEN $1 IS NULL AND $2 IS NULL THEN NULL
        WHEN $1 IS NOT NULL THEN calculate_role_priority($1)
        ELSE
          $2::int
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL
      end
    end
  end
end
