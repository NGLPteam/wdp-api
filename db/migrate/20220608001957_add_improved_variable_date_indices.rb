class AddImprovedVariableDateIndices < ActiveRecord::Migration[6.1]
  def up
    execute(<<~SQL.strip_heredoc)
    CREATE INDEX index_nvd_join_desc ON named_variable_dates (entity_type, entity_id, path, value DESC NULLS LAST, "precision" DESC NULLS LAST);

    CREATE INDEX index_nvd_join_asc ON named_variable_dates (entity_type, entity_id, path, value ASC NULLS LAST, "precision" ASC NULLS LAST);
    SQL
  end

  def down
    remove_index :named_variable_dates, :index_nvd_join_asc
    remove_index :named_variable_dates, :index_nvd_join_desc
  end
end
