class AddTitlePrefixFieldToEntities < ActiveRecord::Migration[6.1]
  LANG = "SQL".freeze

  def change
    enable_extension "pg_trgm"

    change_table :entities do |t|
      t.text :search_title

      t.index :search_title, using: :gin, opclass: "gin_trgm_ops"
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION to_prefix_search(text) RETURNS text AS $$
        SELECT LOWER(regexp_replace($1, '[^[:alnum:]]', '', 'g'));
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;

        CREATE FUNCTION to_prefix_search(citext) RETURNS text AS $$
        SELECT to_prefix_search($1::text);
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL

        say_with_time "Populate search titles" do
          execute(<<~SQL).cmdtuples
          UPDATE entities SET search_title = to_prefix_search(title);
          SQL
        end
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION to_prefix_search(citext);
        DROP FUNCTION to_prefix_search(text);
        SQL
      end
    end

    change_column_null :entities, :search_title, false
  end
end
