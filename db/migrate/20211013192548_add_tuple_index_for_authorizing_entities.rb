class AddTupleIndexForAuthorizingEntities < ActiveRecord::Migration[6.1]
  def up
    say_with_time "Adding index for single-user contextual queries" do
      execute(<<~SQL)
      CREATE INDEX index_authorizing_entities_single_user ON authorizing_entities (auth_path, scope) INCLUDE (hierarchical_id, hierarchical_type);
      SQL
    end
  end

  def down
    execute(<<~SQL)
    DROP INDEX index_authorizing_entities_single_user;
    SQL
  end
end
