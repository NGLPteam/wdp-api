class ImproveSemverValidation < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def up
    execute <<~SQL
    CREATE FUNCTION is_valid_semver(text) RETURNS boolean AS $$
    SELECT $1 ~ '^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$';
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION is_valid_semver(jsonb) RETURNS boolean AS $$
    SELECT
    CASE jsonb_typeof($1)
    WHEN 'string' THEN is_valid_semver($1 #>> '{}')
    ELSE
      FALSE
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION parsed_to_semver(parsed_semver) RETURNS semantic_version AS $$
    SELECT CONCAT(
      COALESCE($1.major, 0)::text,
      '.',
      COALESCE($1.minor, 0)::text,
      '.',
      COALESCE($1.patch, 0)::text,
      (
        '-' || $1.pre
      ),
      (
        '+' || $1.build
      )
    );
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
    SQL
  end

  def down
    execute <<~SQL
    DROP FUNCTION parsed_to_semver(parsed_semver);
    DROP FUNCTION is_valid_semver(jsonb);
    DROP FUNCTION is_valid_semver(text);
    SQL
  end
end
