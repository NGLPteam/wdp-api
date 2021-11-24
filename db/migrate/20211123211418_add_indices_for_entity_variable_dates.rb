class AddIndicesForEntityVariableDates < ActiveRecord::Migration[6.1]
  TABLES = %i[collections items].freeze
  COLUMNS = %i[published accessioned available issued]

  def change
    TABLES.each do |table|
      COLUMNS.each do |column|
        reversible do |dir|
          dir.up do
            say_with_time "Creating #{column} sort indices for #{table}" do
              execute(<<~SQL)
              CREATE INDEX index_#{table}_#{column}_sort_asc ON #{table} (((#{column}).value) ASC NULLS LAST);
              CREATE INDEX index_#{table}_#{column}_sort_desc ON #{table} (((#{column}).value) DESC NULLS LAST);
              SQL
            end
          end

          dir.down do
            execute(<<~SQL)
            DROP INDEX index_#{table}_#{column}_sort_asc;
            DROP INDEX index_#{table}_#{column}_sort_desc;
            SQL
          end
        end
      end
    end
  end
end
