class AdjustEntityInstancesToUseVariableDateOperators < ActiveRecord::Migration[6.1]
  TABLES = %i[collections items]

  COLUMNS = %i[published accessioned available issued].freeze

  def up
    say_with_time "Migrating existing values to named_variable_dates" do
      execute(<<~SQL).cmdtuples
      WITH variable_dates AS (
        SELECT 'Item' AS entity_type, id AS entity_id, '$published$' AS path, @ published AS actual FROM items
        UNION ALL
        SELECT 'Item' AS entity_type, id AS entity_id, '$issued$' AS path, @ issued AS actual FROM items
        UNION ALL
        SELECT 'Item' AS entity_type, id AS entity_id, '$accessioned$' AS path, @ accessioned AS actual FROM items
        UNION ALL
        SELECT 'Item' AS entity_type, id AS entity_id, '$available$' AS path, @ available AS actual FROM items
        UNION ALL
        SELECT 'Collection' AS entity_type, id AS entity_id, '$published$' AS path, @ published AS actual FROM collections
        UNION ALL
        SELECT 'Collection' AS entity_type, id AS entity_id, '$issued$' AS path, @ issued AS actual FROM collections
        UNION ALL
        SELECT 'Collection' AS entity_type, id AS entity_id, '$accessioned$' AS path, @ accessioned AS actual FROM collections
        UNION ALL
        SELECT 'Collection' AS entity_type, id AS entity_id, '$available$' AS path, @ available AS actual FROM collections
      )
      INSERT INTO named_variable_dates (entity_type, entity_id, path, actual)
      SELECT * FROM variable_dates
      ON CONFLICT (entity_type, entity_id, path) DO UPDATE SET
        actual = EXCLUDED.actual,
        updated_at = CASE WHEN named_variable_dates.actual <> EXCLUDED.actual THEN CURRENT_TIMESTAMP ELSE named_variable_dates.updated_at END
      ;
      SQL
    end

    TABLES.each do |table|
      COLUMNS.each do |column|
        remove_column table, :"#{column}_precision", if_exists: true
        remove_column table, :"#{column}_range", if_exists: true
        remove_column table, column
      end
    end
  end

  def down
    TABLES.each do |table|
      COLUMNS.each do |column|
        add_variable_precision_date table, column
      end
    end

    say_with_time "Creating temporary view for restoration" do
      execute(<<~SQL)
      CREATE TEMPORARY VIEW nvd_restore AS
        SELECT ent.entity_type, ent.entity_id,
          @ pub.actual AS published,
          @ acc.actual AS accessioned,
          @ ava.actual AS available,
          @ iss.actual AS issued
        FROM (SELECT DISTINCT entity_type, entity_id FROM named_variable_dates) AS ent
        LEFT OUTER JOIN named_variable_dates pub ON ent.entity_type = pub.entity_type AND ent.entity_id = pub.entity_id AND pub.path = '$published$'
        LEFT OUTER JOIN named_variable_dates acc ON ent.entity_type = acc.entity_type AND ent.entity_id = acc.entity_id AND acc.path = '$accessioned$'
        LEFT OUTER JOIN named_variable_dates ava ON ent.entity_type = ava.entity_type AND ent.entity_id = ava.entity_id AND ava.path = '$available$'
        LEFT OUTER JOIN named_variable_dates iss ON ent.entity_type = iss.entity_type AND ent.entity_id = iss.entity_id AND iss.path = '$issued$'
      ;
      SQL
    end

    say_with_time "Restoring collection dates" do
      execute(<<~SQL).cmdtuples
      UPDATE collections AS ent SET published = nvd.published, accessioned = nvd.accessioned, available = nvd.available, issued = nvd.issued
      FROM nvd_restore AS nvd
      WHERE nvd.entity_type = 'Collection' AND nvd.entity_id = ent.id
      SQL
    end

    say_with_time "Restoring item dates" do
      execute(<<~SQL).cmdtuples
      UPDATE items AS ent SET published = nvd.published, accessioned = nvd.accessioned, available = nvd.available, issued = nvd.issued
      FROM nvd_restore AS nvd
      WHERE nvd.entity_type = 'Item' AND nvd.entity_id = ent.id
      SQL
    end

    execute <<~SQL
    DROP VIEW nvd_restore;
    SQL
  end

  private

  def add_variable_precision_date(table, column)
    change_table table do |t|
      t.column column, :variable_precision_date, null: true, default: -> { "'(,none)'" }

      t.index column
    end

    range_column = :"#{column}_range"

    precision_column = :"#{column}_precision"

    quoted_table = connection.quote_table_name table

    quoted_column = connection.quote_column_name column
    quoted_range = connection.quote_column_name range_column
    quoted_precision = connection.quote_column_name precision_column

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE #{quoted_table}
          ADD COLUMN #{quoted_range} daterange GENERATED ALWAYS AS (variable_daterange(#{quoted_column})) STORED,
          ADD COLUMN #{quoted_precision} date_precision GENERATED ALWAYS AS (variable_precision_for(#{quoted_column})) STORED
          ;
        SQL
      end

      dir.down do
        remove_column table, precision_column
        remove_column table, range_column
      end
    end

    change_table table do |t|
      t.index range_column, using: :gist
      t.index precision_column
    end
  end
end
