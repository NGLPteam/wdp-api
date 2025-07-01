# frozen_string_literal: true

class SetDatabaseStatementTimeout < ActiveRecord::Migration[7.0]
  def up
    quoted_database = ApplicationRecord.connection.quote_schema_name(ApplicationRecord.connection.current_database)

    execute <<~SQL
    ALTER DATABASE #{quoted_database} SET statement_timeout = '30min';
    SQL
  end

  def down
    quoted_database = ApplicationRecord.connection.quote_schema_name(ApplicationRecord.connection.current_database)

    execute <<~SQL
    ALTER DATABASE #{quoted_database} RESET statement_timeout;
    SQL
  end
end
