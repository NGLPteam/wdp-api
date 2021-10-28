class AddVariablePrecisionDatesToEntities < ActiveRecord::Migration[6.1]
  TABLES = %i[collections items].freeze
  COLUMNS = %i[published accessioned available issued]

  def change
    TABLES.each do |table|
      COLUMNS.each do |column|
        add_variable_precision_date table, column
      end

      migrate_published_on_to_published! table
    end
  end

  private

  def add_variable_precision_date(table, column, add_range: true)
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
    end if add_range

    change_table table do |t|
      t.index range_column, using: :gist
      t.index precision_column
    end
  end

  def migrate_published_on_to_published!(table)
    reversible do |dir|
      dir.up do
        say_with_time "Migrating #{table}.published_on to variable precision" do
          execute(<<~SQL).cmdtuples
          UPDATE #{connection.quote_table_name(table)} SET published = variable_precision(published_on)
          SQL
        end
      end
    end
  end
end
