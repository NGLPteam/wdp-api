# @note We cannot actually use a real operator class / family on Heroku because of superuser restrictions.
#   We may want to revisit this for performance reasons down the line, but we can work around it for now.
#   The operators necessary to define an operator class are here, and can be used in many cases sans OC.
class AddVariableDateOperatorClass < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def up
    execute <<~SQL
    CREATE FUNCTION vpdate_value_for(date, date_precision) RETURNS date AS $$
    SELECT
    CASE $2
    WHEN 'day' THEN $1
    WHEN 'month' THEN date_trunc('month', $1)::date
    WHEN 'year' THEN date_trunc('year', $1)::date
    ELSE
      NUll
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION variable_precision(date, date_precision) RETURNS variable_precision_date AS $$
    SELECT CASE
    WHEN $1 IS NOT NULL AND $2 IS NOT NULL AND $2 <> 'none' THEN
      ROW(vpdate_value_for($1, $2), $2)::variable_precision_date
    ELSE
      ROW(NULL, 'none')::variable_precision_date
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    COMMENT ON FUNCTION variable_precision(date, date_precision) IS 'Construct a variable precision date from args';

    CREATE OPERATOR + (
      FUNCTION = variable_precision,
      LEFTARG = date,
      RIGHTARG = date_precision,
      COMMUTATOR = +
    );

    COMMENT ON OPERATOR +(date, date_precision) IS 'Construct a variable precision date';

    CREATE FUNCTION variable_precision(date_precision, date) RETURNS variable_precision_date AS $$
    SELECT variable_precision($2, $1);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    COMMENT ON FUNCTION variable_precision(date_precision, date) IS 'Construct a variable precision date from args';

    CREATE OPERATOR + (
      FUNCTION = variable_precision,
      LEFTARG = date_precision,
      RIGHTARG = date,
      COMMUTATOR = +
    );

    COMMENT ON OPERATOR +(date_precision, date) IS 'Construct a variable precision date';

    CREATE FUNCTION vpdate_normalize(variable_precision_date) RETURNS variable_precision_date AS $$
    SELECT CASE
    WHEN $1 IS NULL OR $1.precision = 'none' THEN ROW(NULL, 'none')::variable_precision_date
    ELSE
      variable_precision($1.value, $1.precision)
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR @ (
      FUNCTION = vpdate_normalize,
      RIGHTARG = variable_precision_date
    );

    CREATE FUNCTION vpdate_value(variable_precision_date) RETURNS date AS $$
    SELECT vpdate_value_for($1.value, $1.precision);
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR ~^ (
      FUNCTION = vpdate_value,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR ~^(NONE, variable_precision_date) IS 'Extract the normalized date from a variable precision date';

    CREATE OPERATOR @& (
      FUNCTION = variable_daterange,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR @& (NONE, variable_precision_date) IS 'Transform a variable date into a daterange';

    CREATE OPERATOR ~> (
      FUNCTION = variable_precision_for,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR ~> (NONE, variable_precision_date) IS 'Extract the normalized precision from a variable precision date. Guaranteed to be not-null';

    CREATE FUNCTION is_none(date_precision) RETURNS boolean AS $$
    SELECT $1 IS NULL OR $1 = 'none';
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?- (
      FUNCTION = is_none,
      RIGHTARG = date_precision,
      NEGATOR = ?^
    );

    COMMENT ON OPERATOR ?-(NONE, date_precision) IS 'Check if the date precision is none-valued or null';

    CREATE FUNCTION is_valued(date_precision) RETURNS boolean AS $$
    SELECT $1 IS NOT NULL AND $1 <> 'none';
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?^ (
      FUNCTION = is_valued(date_precision),
      RIGHTARG = date_precision,
      NEGATOR = ?-
    );

    COMMENT ON OPERATOR ?^(NONE, date_precision) IS 'Check if the date precision refers to any real value';

    CREATE FUNCTION vpdate_is_none(variable_precision_date) RETURNS boolean AS $$
    SELECT $1 IS NULL OR ~> $1 = 'none';
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?- (
      FUNCTION = vpdate_is_none,
      RIGHTARG = variable_precision_date,
      NEGATOR = ?^
    );

    COMMENT ON OPERATOR ?-(NONE, variable_precision_date) IS 'Check if the variable precision date is none-valued';

    CREATE FUNCTION vpdate_has_value(variable_precision_date) RETURNS boolean AS $$
    SELECT $1 IS NOT NULL AND ~> $1 <> 'none';
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?^ (
      FUNCTION = vpdate_has_value,
      RIGHTARG = variable_precision_date,
      NEGATOR = ?-
    );

    COMMENT ON OPERATOR ?^(NONE, variable_precision_date) IS 'Check if the variable precision date has a value, aka it is not none-valued';

    CREATE FUNCTION vpdate_cmp_both_valued(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT ?^ $1 AND ?^ $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?^ (
      FUNCTION = vpdate_cmp_both_valued,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?^,
      NEGATOR = -||-
    );

    COMMENT ON OPERATOR ?^(variable_precision_date, variable_precision_date) IS 'Check if both dates have values';

    CREATE FUNCTION vpdate_cmp_any_none(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT ?- $1 OR ?- $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR -||- (
      FUNCTION = vpdate_cmp_any_none,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = -||-,
      NEGATOR = ?^
    );

    COMMENT ON OPERATOR -||-(variable_precision_date, variable_precision_date) IS 'Check if any date is none-valued';

    CREATE FUNCTION vpdate_cmp_xor_valued(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT
    CASE
    WHEN ?- $1 THEN ?^ $2
    WHEN ?^ $1 THEN ?- $2
    ELSE
      FALSE
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ^^ (
      FUNCTION = vpdate_cmp_xor_valued,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ^^
    );

    COMMENT ON OPERATOR ^^(variable_precision_date, variable_precision_date) IS '?^ A XOR ?^ B';

    CREATE FUNCTION vpdate_cmp_both_none(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT ?- $1 AND ?- $2;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ?- (
      FUNCTION = vpdate_cmp_both_none,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?-
    );

    COMMENT ON OPERATOR ?-(variable_precision_date, variable_precision_date) IS 'Check if both dates are none-valued';

    CREATE FUNCTION date_precision_cmp(date_precision, date_precision) RETURNS int AS $$
    SELECT
    CASE
    WHEN ?- $1 AND ?- $2 THEN 0
    -- none-valued dates sort to the end of the set
    WHEN ?- $1 AND ?^ $2 THEN 1
    WHEN ?^ $2 AND ?- $2 THEN -1
    ELSE
      enum_cmp($1, $2)
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ~>? (
      FUNCTION = date_precision_cmp,
      LEFTARG = date_precision,
      RIGHTARG = date_precision
    );

    COMMENT ON OPERATOR ~>?(date_precision, date_precision) IS 'Compare date precisions with none-last logic';

    CREATE FUNCTION vpdate_cmp_precision(variable_precision_date, date_precision) RETURNS int AS $$
    SELECT date_precision_cmp(~> $1, $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ~>? (
      FUNCTION = vpdate_cmp_precision,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision
    );

    COMMENT ON OPERATOR ~>?(variable_precision_date, date_precision) IS 'Compare variable precision dates by precision *only*';

    CREATE FUNCTION vpdate_cmp_precision(date_precision, variable_precision_date) RETURNS int AS $$
    SELECT date_precision_cmp($1, ~> $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ~>? (
      FUNCTION = vpdate_cmp_precision,
      LEFTARG = date_precision,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR ~>?(date_precision, variable_precision_date) IS 'Compare variable precision dates by precision *only*';

    CREATE FUNCTION vpdate_cmp_precision(variable_precision_date, variable_precision_date) RETURNS int AS $$
    SELECT date_precision_cmp(~> $1, ~> $2);
    $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

    CREATE OPERATOR ~>? (
      FUNCTION = vpdate_cmp_precision,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR ~>?(variable_precision_date, variable_precision_date) IS 'Compare variable precision dates by precision *only*';

    CREATE FUNCTION vpdate_precision_lt(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 ~>? $2 < 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_le(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 ~>? $2 <= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_eq(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT ~> $1 = ~> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_neq(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT ~> $1 <> ~> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_ge(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 ~>? $2 >= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_gt(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 ~>? $2 > 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR ?< (
      FUNCTION = vpdate_precision_lt,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?>,
      NEGATOR = ?>=,
      JOIN = scalarltjoinsel,
      RESTRICT = scalarltsel
    );

    COMMENT ON OPERATOR ?<(variable_precision_date, variable_precision_date) IS 'A.precision < B.precision, with none always pushed to the end';

    CREATE OPERATOR ?<= (
      FUNCTION = vpdate_precision_le,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?>=,
      NEGATOR = ?>,
      JOIN = scalarlejoinsel,
      RESTRICT = scalarlesel
    );

    COMMENT ON OPERATOR ?<=(variable_precision_date, variable_precision_date) IS 'A.precision <= B.precision, with none always pushed to the end';

    CREATE OPERATOR ?= (
      FUNCTION = vpdate_precision_eq,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?=,
      NEGATOR = ?!,
      JOIN = eqjoinsel,
      RESTRICT = eqsel,
      HASHES,
      MERGES
    );

    COMMENT ON OPERATOR ?=(variable_precision_date, variable_precision_date) IS 'A.precision = B.precision';

    CREATE OPERATOR ?! (
      FUNCTION = vpdate_precision_neq,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?!,
      NEGATOR = ?=,
      JOIN = neqjoinsel,
      RESTRICT = neqsel
    );

    COMMENT ON OPERATOR ?!(variable_precision_date, variable_precision_date) IS 'A.precision <> B.precision';

    CREATE OPERATOR ?>= (
      FUNCTION = vpdate_precision_ge,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?<=,
      NEGATOR = ?<,
      JOIN = scalargejoinsel,
      RESTRICT = scalargesel
    );

    COMMENT ON OPERATOR ?>=(variable_precision_date, variable_precision_date) IS 'A.precision >= B.precision, with none always pushed to the end';

    CREATE OPERATOR ?> (
      FUNCTION = vpdate_precision_gt,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = ?<,
      NEGATOR = ?<=,
      JOIN = scalargtjoinsel,
      RESTRICT = scalargtsel
    );

    COMMENT ON OPERATOR ?>(variable_precision_date, variable_precision_date) IS 'A.precision > B.precision, with none always pushed to the end';

    CREATE FUNCTION vpdate_precision_lt(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 ~>? $2 < 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_le(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 ~>? $2 <= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_eq(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT ~> $1 = $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_neq(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT ~> $1 <> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_ge(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 ~>? $2 >= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpdate_precision_gt(variable_precision_date, date_precision) RETURNS boolean AS $$
    SELECT $1 ~>? $2 > 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR ?< (
      FUNCTION = vpdate_precision_lt,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      COMMUTATOR = ?>,
      NEGATOR = ?>=,
      JOIN = scalarltjoinsel,
      RESTRICT = scalarltsel
    );

    COMMENT ON OPERATOR ?<(variable_precision_date, date_precision) IS 'A.precision < B, with none always pushed to the end';

    CREATE OPERATOR ?<= (
      FUNCTION = vpdate_precision_le,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      COMMUTATOR = ?>=,
      NEGATOR = ?>,
      JOIN = scalarlejoinsel,
      RESTRICT = scalarlesel
    );

    COMMENT ON OPERATOR ?<=(variable_precision_date, date_precision) IS 'A.precision <= B, with none always pushed to the end';

    CREATE OPERATOR ?= (
      FUNCTION = vpdate_precision_eq,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      NEGATOR = ?!,
      JOIN = eqjoinsel,
      RESTRICT = eqsel
    );

    COMMENT ON OPERATOR ?=(variable_precision_date, date_precision) IS 'A.precision = B';

    CREATE OPERATOR ?! (
      FUNCTION = vpdate_precision_neq,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      NEGATOR = ?=,
      JOIN = neqjoinsel,
      RESTRICT = neqsel
    );

    COMMENT ON OPERATOR ?!(variable_precision_date, date_precision) IS 'A.precision <> B';

    CREATE OPERATOR ?>= (
      FUNCTION = vpdate_precision_ge,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      COMMUTATOR = ?<=,
      NEGATOR = ?<,
      JOIN = scalargejoinsel,
      RESTRICT = scalargesel
    );

    COMMENT ON OPERATOR ?>=(variable_precision_date, date_precision) IS 'A.precision >= B, with none always pushed to the end';

    CREATE OPERATOR ?> (
      FUNCTION = vpdate_precision_gt,
      LEFTARG = variable_precision_date,
      RIGHTARG = date_precision,
      COMMUTATOR = ?<,
      NEGATOR = ?<=,
      JOIN = scalargtjoinsel,
      RESTRICT = scalargtsel
    );

    COMMENT ON OPERATOR ?>(variable_precision_date, date_precision) IS 'A.precision > B, with none always pushed to the end';

    CREATE FUNCTION vpdate_nullif_none(variable_precision_date) RETURNS variable_precision_date AS $$
    SELECT CASE WHEN ?^ $1 THEN @ $1 ELSE NULL END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_nullif_none(variable_precision_date) IS 'Normalize and nullify none-valued variable precision dates';

    CREATE OPERATOR # (
      FUNCTION = vpdate_nullif_none,
      RIGHTARG = variable_precision_date
    );

    COMMENT ON OPERATOR # (NONE, variable_precision_date) IS 'Normalize a variable precision date, but return null if it is none. Intended for ordering so we can easily always sort nulls to last';

    CREATE FUNCTION vpdate_cmp(variable_precision_date, variable_precision_date) RETURNS int AS $$
    SELECT
    CASE
    -- if either are none, we short-circuit and cmp by precision
    WHEN $1 -||- $2 THEN $1 ~>? $2
    WHEN date_cmp(~^ $1, ~^ $2) < 0 THEN -1
    WHEN date_cmp(~^ $1, ~^ $2) > 0 THEN 1
    ELSE
      -- assume dates are the same, cmp by precision
      $1 ~>? $2
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_cmp(variable_precision_date, variable_precision_date) IS 'Base comparison function for operator class. First sort none-valued to the end of the set, then by date, then by precision.';

    CREATE FUNCTION vpdate_lt(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) < 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_lt(variable_precision_date, variable_precision_date) IS 'Implementation for <(variable_precision_date, variable_precision_date)';

    CREATE FUNCTION vpdate_le(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) <= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_le(variable_precision_date, variable_precision_date) IS 'Implementation for <=(variable_precision_date, variable_precision_date)';

    CREATE FUNCTION vpdate_eq(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) = 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_eq(variable_precision_date, variable_precision_date) IS 'Equality function. Implementation for =(variable_precision_date, variable_precision_date)';

    CREATE FUNCTION vpdate_neq(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) <> 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_neq(variable_precision_date, variable_precision_date) IS 'Inequality function. Implementation for <>(variable_precision_date, variable_precision_date), and by proxy, !=';

    CREATE FUNCTION vpdate_ge(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) >= 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_ge(variable_precision_date, variable_precision_date) IS 'Implementation for >=(variable_precision_date, variable_precision_date)';

    CREATE FUNCTION vpdate_gt(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT vpdate_cmp($1, $2) > 0;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    COMMENT ON FUNCTION vpdate_gt(variable_precision_date, variable_precision_date) IS 'Implementation for >(variable_precision_date, variable_precision_date)';

    CREATE OPERATOR < (
      FUNCTION = vpdate_lt,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = >,
      NEGATOR = >=,
      JOIN = scalarltjoinsel,
      RESTRICT = scalarltsel
    );

    COMMENT ON OPERATOR <(variable_precision_date, variable_precision_date) IS 'A < B based on value then precision';

    CREATE OPERATOR <= (
      FUNCTION = vpdate_le,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = >=,
      NEGATOR = >,
      JOIN = scalarlejoinsel,
      RESTRICT = scalarlesel
    );

    COMMENT ON OPERATOR <(variable_precision_date, variable_precision_date) IS 'A <= B based on value then precision';

    CREATE OPERATOR = (
      FUNCTION = vpdate_eq,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = =,
      NEGATOR = <>,
      JOIN = eqjoinsel,
      RESTRICT = eqsel,
      HASHES,
      MERGES
    );

    CREATE OPERATOR <> (
      FUNCTION = vpdate_neq,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = <>,
      NEGATOR = =,
      JOIN = neqjoinsel,
      RESTRICT = neqsel
    );

    CREATE OPERATOR >= (
      FUNCTION = vpdate_ge,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = <=,
      NEGATOR = <,
      JOIN = scalargejoinsel,
      RESTRICT = scalargesel
    );

    COMMENT ON OPERATOR <(variable_precision_date, variable_precision_date) IS 'A >= B based on value then precision';

    CREATE OPERATOR > (
      FUNCTION = vpdate_gt,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = <=,
      NEGATOR = <,
      JOIN = scalargtjoinsel,
      RESTRICT = scalargtsel
    );

    COMMENT ON OPERATOR <(variable_precision_date, variable_precision_date) IS 'A > B based on value then precision';

    CREATE CAST (variable_precision_date AS date)
      WITH FUNCTION vpdate_value(variable_precision_date)
      AS ASSIGNMENT;

    CREATE CAST (variable_precision_date AS daterange)
      WITH FUNCTION variable_daterange(variable_precision_date)
      AS ASSIGNMENT;

    CREATE CAST (date AS variable_precision_date)
      WITH FUNCTION variable_precision(date)
      AS ASSIGNMENT;

    CREATE FUNCTION vpdate_contains(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT @& $1 @> @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR @> (
      FUNCTION = vpdate_contains,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = <@
    );

    CREATE FUNCTION vpdate_contains(variable_precision_date, date) RETURNS boolean AS $$
    SELECT @& $1 @> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR @> (
      FUNCTION = vpdate_contains,
      LEFTARG = variable_precision_date,
      RIGHTARG = date,
      COMMUTATOR = <@
    );

    CREATE FUNCTION vpdate_contains(variable_precision_date, daterange) RETURNS boolean AS $$
    SELECT @& $1 @> $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR @> (
      FUNCTION = vpdate_contains,
      LEFTARG = variable_precision_date,
      RIGHTARG = daterange,
      COMMUTATOR = <@
    );

    CREATE FUNCTION vpdate_contains(daterange, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 @> @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR @> (
      FUNCTION = vpdate_contains,
      LEFTARG = daterange,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = <@
    );

    CREATE FUNCTION vpdate_contained_by(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT @& $1 <@ @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR <@ (
      FUNCTION = vpdate_contained_by,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = @>
    );

    CREATE FUNCTION vpdate_contained_by(date, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 <@ @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR <@ (
      FUNCTION = vpdate_contained_by,
      LEFTARG = date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = @>
    );

    CREATE FUNCTION vpdate_contained_by(variable_precision_date, daterange) RETURNS boolean AS $$
    SELECT @& $1 <@ $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR <@ (
      FUNCTION = vpdate_contained_by,
      LEFTARG = variable_precision_date,
      RIGHTARG = daterange,
      COMMUTATOR = @>
    );

    COMMENT ON OPERATOR <@(variable_precision_date, daterange) IS 'contained by';

    CREATE FUNCTION vpdate_contained_by(daterange, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 <@ @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR <@ (
      FUNCTION = vpdate_contained_by,
      LEFTARG = daterange,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = @>
    );

    COMMENT ON OPERATOR <@(daterange, variable_precision_date) IS 'contained by';

    CREATE FUNCTION vpdate_overlaps(variable_precision_date, variable_precision_date) RETURNS boolean AS $$
    SELECT @& $1 && @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR && (
      FUNCTION = vpdate_overlaps,
      LEFTARG = variable_precision_date,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = &&
    );

    COMMENT ON OPERATOR &&(variable_precision_date, variable_precision_date) IS 'overlaps';

    CREATE FUNCTION vpdate_overlaps(variable_precision_date, daterange) RETURNS boolean AS $$
    SELECT @& $1 && $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR && (
      FUNCTION = vpdate_overlaps,
      LEFTARG = variable_precision_date,
      RIGHTARG = daterange,
      COMMUTATOR = &&
    );

    COMMENT ON OPERATOR &&(variable_precision_date, daterange) IS 'overlaps';

    CREATE FUNCTION vpdate_overlaps(daterange, variable_precision_date) RETURNS boolean AS $$
    SELECT $1 && @& $2;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE OPERATOR && (
      FUNCTION = vpdate_overlaps,
      LEFTARG = daterange,
      RIGHTARG = variable_precision_date,
      COMMUTATOR = &&
    );

    COMMENT ON OPERATOR &&(daterange, variable_precision_date) IS 'overlaps';
    SQL
  end

  def down
    execute <<~SQL
    DROP OPERATOR && (daterange, variable_precision_date);
    DROP FUNCTION vpdate_overlaps(daterange, variable_precision_date);
    DROP OPERATOR && (variable_precision_date, daterange);
    DROP FUNCTION vpdate_overlaps(variable_precision_date, daterange);
    DROP OPERATOR && (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_overlaps(variable_precision_date, variable_precision_date);

    DROP OPERATOR <@ (daterange, variable_precision_date);
    DROP FUNCTION vpdate_contained_by(daterange, variable_precision_date);
    DROP OPERATOR <@ (variable_precision_date, daterange);
    DROP FUNCTION vpdate_contained_by(variable_precision_date, daterange);
    DROP OPERATOR <@ (date, variable_precision_date);
    DROP FUNCTION vpdate_contained_by(date, variable_precision_date);
    DROP OPERATOR <@ (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_contained_by(variable_precision_date, variable_precision_date);

    DROP OPERATOR @> (daterange, variable_precision_date);
    DROP FUNCTION vpdate_contains(daterange, variable_precision_date);
    DROP OPERATOR @> (variable_precision_date, daterange);
    DROP FUNCTION vpdate_contains(variable_precision_date, daterange);
    DROP OPERATOR @> (variable_precision_date, date);
    DROP FUNCTION vpdate_contains(variable_precision_date, date);
    DROP OPERATOR @> (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_contains(variable_precision_date, variable_precision_date);

    DROP CAST (date AS variable_precision_date);

    DROP CAST (variable_precision_date AS daterange);

    DROP CAST (variable_precision_date AS date);

    DROP OPERATOR >(variable_precision_date, variable_precision_date);
    DROP OPERATOR >=(variable_precision_date, variable_precision_date);
    DROP OPERATOR <>(variable_precision_date, variable_precision_date);
    DROP OPERATOR =(variable_precision_date, variable_precision_date);
    DROP OPERATOR <=(variable_precision_date, variable_precision_date);
    DROP OPERATOR <(variable_precision_date, variable_precision_date);

    DROP FUNCTION vpdate_gt(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_ge(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_neq(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_eq(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_le(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_lt(variable_precision_date, variable_precision_date);

    DROP FUNCTION vpdate_cmp(variable_precision_date, variable_precision_date);

    DROP OPERATOR # (NONE, variable_precision_date);
    DROP FUNCTION vpdate_nullif_none(variable_precision_date);

    DROP OPERATOR ?>(variable_precision_date, date_precision);
    DROP OPERATOR ?>=(variable_precision_date, date_precision);
    DROP OPERATOR ?!(variable_precision_date, date_precision);
    DROP OPERATOR ?=(variable_precision_date, date_precision);
    DROP OPERATOR ?<=(variable_precision_date, date_precision);
    DROP OPERATOR ?<(variable_precision_date, date_precision);

    DROP FUNCTION vpdate_precision_gt(variable_precision_date, date_precision);
    DROP FUNCTION vpdate_precision_ge(variable_precision_date, date_precision);
    DROP FUNCTION vpdate_precision_neq(variable_precision_date, date_precision);
    DROP FUNCTION vpdate_precision_eq(variable_precision_date, date_precision);
    DROP FUNCTION vpdate_precision_le(variable_precision_date, date_precision);
    DROP FUNCTION vpdate_precision_lt(variable_precision_date, date_precision);

    DROP OPERATOR ?>(variable_precision_date, variable_precision_date);
    DROP OPERATOR ?>=(variable_precision_date, variable_precision_date);
    DROP OPERATOR ?!(variable_precision_date, variable_precision_date);
    DROP OPERATOR ?=(variable_precision_date, variable_precision_date);
    DROP OPERATOR ?<=(variable_precision_date, variable_precision_date);
    DROP OPERATOR ?<(variable_precision_date, variable_precision_date);

    DROP FUNCTION vpdate_precision_gt(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_precision_ge(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_precision_neq(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_precision_eq(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_precision_le(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_precision_lt(variable_precision_date, variable_precision_date);

    DROP OPERATOR ~>? (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_cmp_precision(variable_precision_date, variable_precision_date);

    DROP OPERATOR ~>? (date_precision, variable_precision_date);
    DROP FUNCTION vpdate_cmp_precision(date_precision, variable_precision_date);

    DROP OPERATOR ~>? (variable_precision_date, date_precision);
    DROP FUNCTION vpdate_cmp_precision(variable_precision_date, date_precision);

    DROP OPERATOR ~>? (date_precision, date_precision);
    DROP FUNCTION date_precision_cmp(date_precision, date_precision);

    DROP OPERATOR ?- (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_cmp_both_none(variable_precision_date, variable_precision_date);

    DROP OPERATOR ^^ (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_cmp_xor_valued(variable_precision_date, variable_precision_date);

    DROP OPERATOR -||-(variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_cmp_any_none(variable_precision_date, variable_precision_date);

    DROP OPERATOR ?^ (variable_precision_date, variable_precision_date);
    DROP FUNCTION vpdate_cmp_both_valued(variable_precision_date, variable_precision_date);

    DROP OPERATOR ?^ (NONE, variable_precision_date);
    DROP FUNCTION vpdate_has_value(variable_precision_date);

    DROP OPERATOR ?- (NONE, variable_precision_date);
    DROP FUNCTION vpdate_is_none(variable_precision_date);

    DROP OPERATOR ?^ (NONE, date_precision);
    DROP FUNCTION is_valued(date_precision);

    DROP OPERATOR ?- (NONE, date_precision);
    DROP FUNCTION is_none(date_precision);

    DROP OPERATOR ~> (NONE, variable_precision_date);
    DROP OPERATOR @& (NONE, variable_precision_date);
    DROP OPERATOR ~^ (NONE, variable_precision_date);

    DROP FUNCTION vpdate_value(variable_precision_date);

    DROP OPERATOR @ (NONE, variable_precision_date);

    DROP FUNCTION vpdate_normalize(variable_precision_date);

    DROP OPERATOR +(date, date_precision), +(date_precision, date);

    DROP FUNCTION variable_precision(date_precision, date);

    DROP FUNCTION variable_precision(date, date_precision);

    DROP FUNCTION vpdate_value_for(date, date_precision);
    SQL
  end
end
