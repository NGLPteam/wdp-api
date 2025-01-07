# frozen_string_literal: true

class FixFunctions < ActiveRecord::Migration[7.0]
  LANG = LANG1 = "SQL"
  LANG2 = "plpgsql"

  PATTERN = Base64.decode64(<<~BASE64.strip_heredoc)
  XigwfFsxLTldXGQqKVwuKDB8WzEtOV1cZCopXC4oMHxbMS05XVxkKikoPzot
  KCg/OjB8WzEtOV1cZCp8XGQqW2EtekEtWi1dWzAtOWEtekEtWi1dKikoPzpc
  Lig/OjB8WzEtOV1cZCp8XGQqW2EtekEtWi1dWzAtOWEtekEtWi1dKikpKikp
  Pyg/OlwrKFswLTlhLXpBLVotXSsoPzpcLlswLTlhLXpBLVotXSspKikpPyQ=
  BASE64

  def up
    execute <<~SQL
    CREATE OR REPLACE FUNCTION public.ltree_generations(ltree, ltree, ltree) RETURNS bigint AS $$
    SELECT public.nlevel(
      public.subltree(
        $1,
        public.index($1, $2),
        public.index($1, $3, public.index($1, $2))
      )
    );
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.is_valid_semver(jsonb) RETURNS boolean AS $$
    SELECT
    CASE jsonb_typeof($1)
    WHEN 'string' THEN public.is_valid_semver($1 #>> '{}')
    ELSE
      FALSE
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION try_cast_variable_precision_date(text) RETURNS variable_precision_date AS $$
    BEGIN
      BEGIN
        RETURN CAST($1 AS public.variable_precision_date);
      EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
      END;
    END;
    $$ LANGUAGE #{LANG2} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_text(jsonb) RETURNS text AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN $1 #>> '{}' ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_citext(jsonb) RETURNS citext AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN CAST($1 #>> '{}' AS public.citext) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_boolean(jsonb) RETURNS boolean AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'boolean' THEN CAST($1 #>> '{}' AS boolean) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_numeric(jsonb) RETURNS decimal AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'number' THEN CAST ($1 #>> '{}' AS numeric) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_bigint(jsonb) RETURNS bigint AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'number' THEN COALESCE(public.try_cast_bigint($1 #>> '{}'), CAST(CAST($1 #>> '{}' AS numeric) AS bigint)) ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_date(jsonb) RETURNS date AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN public.try_cast_date($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_timestamptz(jsonb) RETURNS timestamptz AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN public.try_cast_timestamptz($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_to_variable_precision_date(jsonb) RETURNS variable_precision_date AS $$
    SELECT CASE WHEN jsonb_typeof($1) = 'string' THEN public.try_cast_variable_precision_date($1 #>> '{}') ELSE NULL END;
    $$ LANGUAGE #{LANG1} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_set_rec(jsonb, jsonb, text[]) RETURNS jsonb AS $$
      SELECT CASE
      WHEN array_length($3, 1) > 1 and ($1 #> $3[:array_upper($3, 1) - 1]) is null
      THEN public.jsonb_set_rec($1, jsonb_build_object($3[array_upper($3, 1)], $2), $3[:array_upper($3, 1) - 1])
      ELSE jsonb_set($1, $3, $2, true)
      END
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_extract_boolean(jsonb, text[]) RETURNS boolean AS $$
    SELECT CASE jsonb_typeof($1 #> $2) WHEN 'boolean' THEN ($1 #> $2)::boolean ELSE FALSE END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION jsonb_bool_or_rec(jsonb, boolean, text[]) RETURNS jsonb AS $$
    SELECT public.jsonb_set_rec($1, to_jsonb(public.jsonb_extract_boolean($1, $3) OR $2), $3);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION array_distinct(anycompatiblearray) RETURNS anycompatiblearray AS $$
    SELECT array_agg(DISTINCT x) FILTER (WHERE x IS NOT NULL) FROM unnest($1) t(x);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION record_is_skipped(jsonb) RETURNS boolean AS $$
    SELECT public.jsonb_extract_boolean($1, '{active}');
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION variable_precision_for(variable_precision_date) RETURNS public.date_precision AS $$
    SELECT CASE
    WHEN $1 IS NOT NULL AND $1.value IS NOT NULL AND $1.precision IS NOT NULL THEN $1.precision
    ELSE
      'none'::public.date_precision
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION variable_precision(date) RETURNS public.variable_precision_date AS $$
    SELECT CASE
    WHEN $1 IS NOT NULL THEN ROW($1, 'day')::public.variable_precision_date
    ELSE
      ROW(NULL, 'none')::public.variable_precision_date
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_has_value(public.variable_precision_date) RETURNS boolean AS $$
    SELECT $1 IS NOT NULL AND OPERATOR(public.~>) $1 <> 'none'::public.date_precision;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_nullif_none(variable_precision_date) RETURNS public.variable_precision_date AS $$
    SELECT CASE WHEN OPERATOR(public.?^) $1 THEN OPERATOR(public.@) $1 ELSE NULL END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_normalize(public.variable_precision_date) RETURNS public.variable_precision_date AS $$
    SELECT CASE
    WHEN $1 IS NULL OR $1.precision = 'none'::public.date_precision THEN ROW(NULL, 'none')::public.variable_precision_date
    ELSE
      public.variable_precision($1.value, $1.precision)
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_value(variable_precision_date) RETURNS date AS $$
    SELECT public.vpdate_value_for($1.value, $1.precision);
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.variable_precision(date, public.date_precision) RETURNS public.variable_precision_date AS $$
    SELECT CASE
    WHEN $1 IS NOT NULL AND $2 IS NOT NULL AND $2 <> 'none'::public.date_precision THEN
    ROW(public.vpdate_value_for($1, $2), $2)::public.variable_precision_date
    ELSE
      ROW(NULL, 'none')::public.variable_precision_date
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.variable_precision(public.date_precision, date) RETURNS public.variable_precision_date AS $$
    SELECT public.variable_precision($2, $1);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.calculate_actions(jsonb) RETURNS TABLE(action public.ltree, allowed boolean) AS $$
    WITH RECURSIVE flattened (scope, value) AS (
      SELECT
        grid.scope::public.ltree AS scope,
        grid.value AS value
        FROM jsonb_each($1) AS grid(scope, value)
        WHERE jsonb_typeof($1) = 'object'
      UNION ALL
      SELECT
        flattened.scope OPERATOR(public.||) COALESCE(grid.scope, '') AS scope,
        grid.value AS value
      FROM
        flattened, jsonb_each(flattened.value) AS grid(scope, value)
      WHERE jsonb_typeof(flattened.value) = 'object'
    ), actions AS (
      SELECT action.action, action.allowed
      FROM
        flattened,
        public.calculate_action(flattened.scope, flattened.value) AS action(action, allowed)
      WHERE jsonb_typeof(flattened.value) = 'boolean'
    ) SELECT DISTINCT ON (action) action, allowed FROM actions WHERE action IS NOT NULL;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.calculate_allowed_actions(jsonb) RETURNS public.ltree[] AS $$
    SELECT COALESCE(
      array_agg(action ORDER BY action) FILTER (WHERE allowed),
      '{}'::public.ltree[]
    ) FROM public.calculate_actions($1) AS t(action, allowed)
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.calculate_role_kind(public.role_identifier) RETURNS role_kind AS $$
    SELECT CASE
    WHEN $1 IS NOT NULL THEN 'system'
    ELSE
      'custom'
    END::public.role_kind;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.calculate_role_primacy(public.role_identifier) RETURNS public.role_primacy AS $$
    SELECT CASE $1
    WHEN 'admin'::public.role_identifier THEN 'high'
    WHEN 'reader'::public.role_identifier THEN 'low'
    ELSE
      'default'
    END::public.role_primacy;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.calculate_role_priority(role_identifier, smallint) RETURNS int AS $$
    SELECT CASE
    WHEN $1 IS NULL AND $2 IS NULL THEN NULL
    WHEN $1 IS NOT NULL THEN public.calculate_role_priority($1)
    ELSE
      $2::int
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.to_schema_kind(text) RETURNS public.schema_kind AS $$
    SELECT CASE WHEN $1 = ANY(enum_range(NULL::public.schema_kind)::text[]) THEN $1::public.schema_kind ELSE NULL END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.parse_semver(text) RETURNS public.parsed_semver AS $$
    SELECT (a[1], a[2], a[3], a[4], a[5])::public.parsed_semver
    FROM (
      SELECT
      '#{PATTERN}'
      AS pat
    ) p
    LEFT JOIN LATERAL (
      SELECT regexp_matches($1, p.pat) AS a
    ) match ON true
    WHERE match.a IS NOT NULL;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_is_none(public.variable_precision_date) RETURNS boolean AS $$
    SELECT $1 IS NULL OR OPERATOR(public.~>) $1 = 'none'::public.date_precision;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_cmp_both_valued(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT OPERATOR(public.?^) $1 AND OPERATOR(public.?^) $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.vpdate_cmp_any_none(public.variable_precision_date, public.variable_precision_date) RETURNS boolean AS $$
    SELECT OPERATOR(public.?-) $1 OR OPERATOR(public.?-) $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.vpdate_cmp_xor_valued(public.variable_precision_date, public.variable_precision_date) RETURNS boolean AS $$
    SELECT
    CASE
    WHEN OPERATOR(public.?-) $1 THEN OPERATOR(public.?^) $2
    WHEN OPERATOR(public.?^) $1 THEN OPERATOR(public.?-) $2
    ELSE
      FALSE
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.vpdate_cmp_both_none(public.variable_precision_date, public.variable_precision_date) RETURNS boolean AS $$
    SELECT OPERATOR(public.?-) $1 AND OPERATOR(public.?-) $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.date_precision_cmp(public.date_precision, public.date_precision) RETURNS int AS $$
    SELECT
    CASE
    WHEN OPERATOR(public.?-) $1 AND OPERATOR(public.?-) $2 THEN 0
    -- none-valued dates sort to the end of the set
    WHEN OPERATOR(public.?-) $1 AND OPERATOR(public.?^) $2 THEN 1
    WHEN OPERATOR(public.?^) $2 AND OPERATOR(public.?-) $2 THEN -1
    ELSE
      enum_cmp($1, $2)
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_cmp_precision(public.date_precision, public.variable_precision_date) RETURNS int AS $$
    SELECT public.date_precision_cmp($1, OPERATOR(public.~>) $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.vpdate_cmp_precision(public.variable_precision_date, public.variable_precision_date) RETURNS int AS $$
    SELECT public.date_precision_cmp(OPERATOR(public.~>) $1, OPERATOR(public.~>) $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION public.vpdate_cmp_precision(public.variable_precision_date, public.date_precision) RETURNS int AS $$
    SELECT public.date_precision_cmp(OPERATOR(public.~>) $1, $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_lt(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 OPERATOR(public.~>?) $2 < 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_le(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 OPERATOR(public.~>?) $2 <= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_eq(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT OPERATOR(public.~>) $1 = $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_neq(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT OPERATOR(public.~>) $1 <> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_ge(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 OPERATOR(public.~>?) $2 >= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OR REPLACE FUNCTION vpdate_precision_gt(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 OPERATOR(public.~>?) $2 > 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
    SQL

    PROP_TYPES.each do |prop_type|
      execute prop_type.create_generate_fn_expression
    end
  end

  def down
    # Intentionally left blank
  end

  class PropType
    LANG = "SQL".freeze

    include Dry::Initializer[undefined: false].define -> do
      param :local_type, Dry::Types["coercible.symbol"]
      param :pg_type, Dry::Types["coercible.symbol"], default: proc { local_type }

      option :custom_pg_type, Dry::Types["bool"], default: proc { false }
      option :pg_schema, Dry::Types["string"], default: proc { "public" }
      option :convert_fn, Dry::Types["string"], default: proc { "jsonb_to_#{pg_type}" }
      option :column_name, Dry::Types["coercible.symbol"], default: proc { :"#{local_type}_value" }
      option :generate_fn, Dry::Types["string"], default: proc { "generate_#{column_name}" }
    end

    def add_column_expression
      <<~SQL.strip_heredoc.squish
      ALTER TABLE entity_orderable_properties
        ADD COLUMN #{column_name} #{quoted_pg_type} GENERATED ALWAYS AS (#{generate_expression}) STORED;
      SQL
    end

    def drop_column_expression
      <<~SQL.strip_heredoc
      ALTER TABLE entity_orderable_properties
        DROP COLUMN IF EXISTS #{column_name};
      SQL
    end

    def generate_fn_signature()
      %[#{generate_fn}(schema_property_type, jsonb)]
    end

    def create_generate_fn_expression
      <<~SQL.strip_heredoc
      CREATE OR REPLACE FUNCTION #{pg_schema}.#{generate_fn_signature} RETURNS #{quoted_pg_type} AS $$
      SELECT CASE WHEN $1 = #{quoted_type} THEN #{pg_schema}.#{convert_fn}($2) ELSE NULL END;
      $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
      SQL
    end

    def indices
      [
        build_index(index_name, "ASC NULLS LAST"),
        build_index(inverted_index_name, "DESC NULLS LAST"),
      ]
    end

    def quoted_type
      quote local_type
    end

    private

    def build_index(name, order, expression: index_expression)
      [
        expression,
        {
          name: name,
          order: {
            column_name => order
          }
        }
      ]
    end

    def generate_expression
      <<~SQL
      #{generate_fn}("type", "raw_value")
      SQL
    end

    def index_expression
      %I[entity_type entity_id path #{column_name}]
    end

    def index_name
      "index_eop_#{local_type}"
    end

    def inverted_index_name
      "index_eop_#{local_type}_inverted"
    end

    def quote(value)
      ApplicationRecord.connection.quote value
    end

    def quoted_pg_type
      if custom_pg_type
        sch = ApplicationRecord.connection.quote_schema_name pg_schema

        typ = ApplicationRecord.connection.quote_column_name pg_type

        "#{sch}.#{typ}"
      else
        pg_type
      end
    end
  end

  PROP_TYPES = [
    PropType.new(:boolean),
    PropType.new(:date),
    PropType.new(:email, :citext, custom_pg_type: true),
    PropType.new(:float, :numeric),
    PropType.new(:integer, :bigint),
    PropType.new(:string, :text),
    PropType.new(:timestamp, :timestamptz),
    PropType.new(:variable_date, :variable_precision_date, custom_pg_type: true),
  ]

end
