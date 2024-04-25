class AddArrayAccumulatorAggregate < ActiveRecord::Migration[6.1]
  def up
    lang = "SQL"

    execute <<~SQL.strip_heredoc.squish
    CREATE FUNCTION jsonb_set_rec(jsonb, jsonb, text[]) RETURNS jsonb AS $$
      SELECT CASE
      WHEN array_length($3, 1) > 1 and ($1 #> $3[:array_upper($3, 1) - 1]) is null
      THEN jsonb_set_rec($1, jsonb_build_object($3[array_upper($3, 1)], $2), $3[:array_upper($3, 1) - 1])
      ELSE jsonb_set($1, $3, $2, true)
      END
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE FUNCTION jsonb_extract_boolean(jsonb, text[]) RETURNS boolean AS $$
    SELECT CASE jsonb_typeof($1 #> $2) WHEN 'boolean' THEN ($1 #> $2)::boolean ELSE FALSE END;
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE FUNCTION jsonb_bool_or_rec(jsonb, boolean, text[]) RETURNS jsonb AS $$
    SELECT jsonb_set_rec($1, to_jsonb(jsonb_extract_boolean($1, $3) OR $2), $3);
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE FUNCTION array_distinct(anycompatiblearray) RETURNS anycompatiblearray AS $$
    SELECT array_agg(DISTINCT x) FILTER (WHERE x IS NOT NULL) FROM unnest($1) t(x);
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE AGGREGATE jsonb_set_agg(jsonb, text[]) (
      sfunc    = jsonb_set_rec,
      stype    = jsonb,
      initcond = '{}'
    );

    CREATE AGGREGATE jsonb_bool_or(boolean, text[]) (
      sfunc    = jsonb_bool_or_rec,
      stype    = jsonb,
      initcond = '{}'
    );

    CREATE AGGREGATE array_accum(anycompatiblearray) (
      sfunc     = array_cat,
      stype     = anycompatiblearray,
      initcond  = '{}'
    );

    CREATE AGGREGATE array_accum_distinct(anycompatiblearray) (
      sfunc     = array_cat,
      stype     = anycompatiblearray,
      finalfunc = array_distinct,
      initcond  = '{}'
    );

    CREATE TYPE jsonb_auth_path_state AS (
      path      ltree,
      granted   boolean
    );

    CREATE FUNCTION _jsonb_auth_path_acc(jsonb_auth_path_state[], ltree, boolean) RETURNS jsonb_auth_path_state[] AS $$
    SELECT $1 || ($2, $3)::jsonb_auth_path_state;
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE FUNCTION _jsonb_auth_path_final(jsonb_auth_path_state[]) RETURNS jsonb AS $$
    SELECT
      jsonb_set_agg(to_jsonb(x.granted), string_to_array(x.path::text, '.'))
      FROM (
        SELECT y.path, bool_or(y.granted) AS granted
        FROM unnest($1) AS y(path, granted)
        GROUP BY y.path
      ) x
    $$ LANGUAGE #{lang} IMMUTABLE;

    CREATE AGGREGATE jsonb_auth_path(ltree, boolean) (
      sfunc     = _jsonb_auth_path_acc,
      stype     = jsonb_auth_path_state[],
      finalfunc = _jsonb_auth_path_final,
      initcond  = '{}'
    );
    SQL
  end

  def down
    execute <<~SQL.strip_heredoc.squish
    DROP AGGREGATE jsonb_auth_path(ltree, boolean);
    DROP FUNCTION _jsonb_auth_path_final(jsonb_auth_path_state[]);
    DROP FUNCTION _jsonb_auth_path_acc(jsonb_auth_path_state[], ltree, boolean);
    DROP AGGREGATE array_accum_distinct(anycompatiblearray);
    DROP AGGREGATE array_accum(anycompatiblearray);
    DROP AGGREGATE jsonb_set_agg(jsonb, text[]);
    DROP AGGREGATE jsonb_bool_or(boolean, text[]);
    DROP FUNCTION jsonb_bool_or_rec(jsonb, boolean, text[]);
    DROP FUNCTION jsonb_extract_boolean(jsonb, text[]);
    DROP FUNCTION array_distinct(anycompatiblearray);
    DROP FUNCTION jsonb_set_rec(jsonb, jsonb, text[]);
    DROP TYPE jsonb_auth_path_state;
    SQL
  end
end
