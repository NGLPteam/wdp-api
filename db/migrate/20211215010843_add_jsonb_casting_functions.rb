# frozen_string_literal: true

class AddJsonbCastingFunctions < ActiveRecord::Migration[6.1]
  LANG1 = "SQL"
  LANG2 = "plpgsql"

  def up
    execute <<~SQL
    CREATE FUNCTION try_cast_bigint(text) RETURNS bigint AS $$
    BEGIN
      BEGIN
        RETURN CAST($1 AS bigint);
      EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
      END;
    END;
    $$ LANGUAGE #{LANG2} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION try_cast_date(text, format text DEFAULT 'YYYY-MM-DD') RETURNS date AS $$
    BEGIN
      BEGIN
        RETURN to_date($1, $2);
      EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
      END;
    END;
    $$ LANGUAGE #{LANG2} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION try_cast_timestamptz(text) RETURNS timestamptz AS $$
    BEGIN
      BEGIN
        RETURN CAST($1 AS timestamptz);
      EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
      END;
    END;
    $$ LANGUAGE #{LANG2} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION try_cast_variable_precision_date(text) RETURNS variable_precision_date AS $$
    BEGIN
      BEGIN
        RETURN CAST($1 AS variable_precision_date);
      EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
      END;
    END;
    $$ LANGUAGE #{LANG2} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_text(jsonb) RETURNS text AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN $1 #>> '{}' ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_citext(jsonb) RETURNS citext AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN CAST($1 #>> '{}' AS citext) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_boolean(jsonb) RETURNS boolean AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'boolean' THEN CAST($1 #>> '{}' AS boolean) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_numeric(jsonb) RETURNS decimal AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'number' THEN CAST ($1 #>> '{}' AS numeric) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_bigint(jsonb) RETURNS bigint AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'number' THEN COALESCE(try_cast_bigint($1 #>> '{}'), CAST(CAST($1 #>> '{}' AS numeric) AS bigint)) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_date(jsonb) RETURNS date AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN try_cast_date($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_timestamptz(jsonb) RETURNS timestamptz AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN try_cast_timestamptz($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION jsonb_to_variable_precision_date(jsonb) RETURNS variable_precision_date AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN try_cast_variable_precision_date($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;
    SQL
  end

  def down
    execute <<~SQL
    DROP FUNCTION jsonb_to_variable_precision_date(jsonb);
    DROP FUNCTION jsonb_to_timestamptz(jsonb);
    DROP FUNCTION jsonb_to_date(jsonb);
    DROP FUNCTION jsonb_to_bigint(jsonb);
    DROP FUNCTION jsonb_to_numeric(jsonb);
    DROP FUNCTION jsonb_to_boolean(jsonb);
    DROP FUNCTION jsonb_to_citext(jsonb);
    DROP FUNCTION jsonb_to_text(jsonb);
    DROP FUNCTION try_cast_variable_precision_date(text);
    DROP FUNCTION try_cast_timestamptz(text);
    DROP FUNCTION try_cast_date(text, text);
    DROP FUNCTION try_cast_bigint(text);
    SQL
  end
end
