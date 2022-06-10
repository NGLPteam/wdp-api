class AddStatStatements < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
    CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
    SQL
  end

  def down
    # Intentionally left blank
  end
end
