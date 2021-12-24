class AddVariablePrecisionDateAggregates < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def up
    execute <<~SQL
    CREATE FUNCTION vpd_least(variable_precision_date, variable_precision_date) RETURNS variable_precision_date AS $$
    SELECT
    CASE
    WHEN $1 -||- $2 THEN
      CASE
      WHEN $1 ?- $2 THEN $1
      WHEN ?- $1 AND ?^ $2 THEN $2
      WHEN ?^ $1 AND ?- $2 THEN $1
      ELSE
        $1
      END
    WHEN ($2).value < ($1).value THEN $2
    ELSE
      $1
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE FUNCTION vpd_greatest(variable_precision_date, variable_precision_date) RETURNS variable_precision_date AS $$
    SELECT
    CASE
    WHEN $1 -||- $2 THEN
      CASE
      WHEN $1 ?- $2 THEN $1
      WHEN ?- $1 AND ?^ $2 THEN $2
      WHEN ?^ $1 AND ?- $2 THEN $1
      ELSE
        $1
      END
    WHEN ($2).value > ($1).value THEN $2
    ELSE
      $1
    END;
    $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

    CREATE AGGREGATE MIN(variable_precision_date) (
      SFUNC = vpd_least,
      STYPE = variable_precision_date,
      FINALFUNC = vpdate_nullif_none,
      MSFUNC = vpd_least,
      MINVFUNC = vpd_greatest,
      MSTYPE = variable_precision_date,
      SORTOP = <,
      PARALLEL = SAFE
    );

    CREATE AGGREGATE MAX(variable_precision_date) (
      SFUNC = vpd_greatest,
      STYPE = variable_precision_date,
      FINALFUNC = vpdate_nullif_none,
      MSFUNC = vpd_greatest,
      MINVFUNC = vpd_least,
      MSTYPE = variable_precision_date,
      SORTOP = >,
      PARALLEL = SAFE
    );
    SQL
  end

  def down
    execute <<~SQL
    DROP AGGREGATE MAX(variable_precision_date);

    DROP AGGREGATE MIN(variable_precision_date);

    DROP FUNCTION vpd_greatest(variable_precision_date, variable_precision_date);

    DROP FUNCTION vpd_least(variable_precision_date, variable_precision_date);
    SQL
  end
end
