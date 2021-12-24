class RemoveSystemSlugFromDefinitionsAndVersions < ActiveRecord::Migration[6.1]
  TABLES = %i[schema_definitions schema_versions]

  def up
    TABLES.each do |table|
      remove_column table, :system_slug
    end
  end

  def down
    TABLES.each do |table|
      add_system_slug_back_to! table
    end
  end

  private

  def add_system_slug_back_to!(table)
    add_column table, :system_slug, :citext

    say_with_time "Repopulating #{table}.system_slug" do
      execute(<<~SQL).cmdtuples
      UPDATE #{table} SET system_slug = declaration;
      SQL
    end

    change_column_null table, :system_slug, false

    add_index table, :system_slug, unique: true
  end
end
