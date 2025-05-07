# frozen_string_literal: true

class AddSearchFunctions < ActiveRecord::Migration[7.0]
  LANG = "SQL"

  # @return [void]
  def up
    enable_extension "unaccent"

    execute <<~SQL
    CREATE FUNCTION jsonb_extract_strings(jsonb) RETURNS SETOF text AS $$
    WITH RECURSIVE extracted_objects(path, value) AS (
      SELECT
        key AS path,
        value
      FROM pg_catalog.jsonb_each(jsonb_build_object('input', $1)) AS t(key, value)
      UNION ALL
      SELECT
      path || '.' || COALESCE(obj_key, (arr_key- 1)::text),
      COALESCE(obj_value, arr_value)
      FROM extracted_objects
      LEFT JOIN LATERAL
      jsonb_each(case jsonb_typeof(value) when 'object' then value end)
      AS o(obj_key, obj_value)
      ON jsonb_typeof(value) = 'object'
      LEFT JOIN LATERAL
      jsonb_array_elements(CASE jsonb_typeof(value) WHEN 'array' THEN value END)
      WITH ORDINALITY AS a(arr_value, arr_key)
      ON jsonb_typeof(value) = 'array'
      WHERE obj_key IS NOT NULL or arr_key IS NOT NULL
    )
    SELECT
      value #>> '{}'
    FROM extracted_objects
      WHERE jsonb_typeof(value) = 'string'
    ;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION public.immutable_unaccent(text) RETURNS text AS $$
    SELECT public.unaccent('public.unaccent'::regdictionary, $1);
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION public.immutable_unaccent(text) IS 'An expression-indexable version of unaccent that uses the default dictionary.';

    CREATE FUNCTION public.to_unaccented_tsv(jsonb) RETURNS tsvector AS $$
    SELECT pg_catalog.to_tsvector('pg_catalog.simple'::regconfig, COALESCE(pg_catalog.STRING_AGG(public.immutable_unaccent(str), ' '), ''))
    FROM public.jsonb_extract_strings($1) AS t(str);
    $$ LANGUAGE #{LANG} IMMUTABLE CALLED ON NULL INPUT PARALLEL SAFE;

    CREATE FUNCTION public.to_unaccented_tsv(text) RETURNS tsvector AS $$
    SELECT pg_catalog.to_tsvector('pg_catalog.simple'::regconfig, COALESCE(public.immutable_unaccent($1), ''));
    $$ LANGUAGE #{LANG} IMMUTABLE CALLED ON NULL INPUT PARALLEL SAFE;

    CREATE FUNCTION public.to_unaccented_weighted_tsv(jsonb, "char") RETURNS tsvector AS $$
    SELECT pg_catalog.setweight(public.to_unaccented_tsv($1), $2);
    $$ LANGUAGE #{LANG} IMMUTABLE CALLED ON NULL INPUT PARALLEL SAFE;

    CREATE FUNCTION public.to_unaccented_weighted_tsv(text, "char") RETURNS tsvector AS $$
    SELECT pg_catalog.setweight(public.to_unaccented_tsv($1), $2);
    $$ LANGUAGE #{LANG} IMMUTABLE CALLED ON NULL INPUT PARALLEL SAFE;
    SQL
  end

  def down
    execute <<~SQL
    DROP FUNCTION public.to_unaccented_weighted_tsv(text, "char");
    DROP FUNCTION public.to_unaccented_weighted_tsv(jsonb, "char");
    DROP FUNCTION public.to_unaccented_tsv(text);
    DROP FUNCTION public.to_unaccented_tsv(jsonb);
    DROP FUNCTION public.immutable_unaccent(text);
    DROP FUNCTION public.jsonb_extract_strings(jsonb);

    DROP EXTENSION IF EXISTS "unaccent"
    SQL
  end
end
