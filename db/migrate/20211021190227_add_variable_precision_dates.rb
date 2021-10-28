# frozen_string_literal: true

class AddVariablePrecisionDates < ActiveRecord::Migration[6.1]
  LANG = "SQL"

  def change
    create_enum "date_precision", %w[none year month day]

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE TYPE variable_precision_date AS (
          value date,
          precision date_precision
        );

        CREATE FUNCTION variable_daterange(variable_precision_date) RETURNS daterange AS $$
        SELECT CASE WHEN $1.value IS NOT NULL THEN
          CASE $1.precision
          WHEN 'day' THEN daterange($1.value, $1.value, '[]')
          WHEN 'month' THEN daterange(
            date_trunc('month', $1.value)::date,
            (date_trunc('month', $1.value) + INTERVAL '1 month')::date,
            '[)')
          WHEN 'year' THEN daterange(
            date_trunc('year', $1.value)::date,
            (date_trunc('year', $1.value) + INTERVAL '1 year')::date,
            '[)')
          ELSE
            NULL
          END
        ELSE
          NUll
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

        CREATE FUNCTION variable_precision_for(variable_precision_date) RETURNS date_precision AS $$
        SELECT CASE
        WHEN $1 IS NOT NULL AND $1.value IS NOT NULL AND $1.precision IS NOT NULL THEN $1.precision
        ELSE
          'none'::date_precision
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;

        CREATE FUNCTION variable_precision(date) RETURNS variable_precision_date AS $$
        SELECT CASE
        WHEN $1 IS NOT NULL THEN ROW($1, 'day')::variable_precision_date
        ELSE
          ROW(NULL, 'none')::variable_precision_date
        END;
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION variable_precision(date);
        DROP FUNCTION variable_precision_for(variable_precision_date);
        DROP FUNCTION variable_daterange(variable_precision_date);
        DROP TYPE variable_precision_date;
        SQL
      end
    end
  end
end
