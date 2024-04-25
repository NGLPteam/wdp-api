class AlterEntityVisibility < ActiveRecord::Migration[6.1]
  TABLES = %i[collections items].freeze
  LANG = "SQL".freeze

  def change
    create_enum :entity_visibility, %i[visible hidden limited]

    reversible do |dir|
      dir.up do
        say_with_time "Adding calculate_visibility_range" do
          execute <<~SQL
          CREATE FUNCTION calculate_visibility_range(entity_visibility, after timestamptz, until timestamptz) RETURNS tstzrange AS $$
          SELECT CASE
          WHEN $1 = 'limited' AND ($2 IS NOT NULL OR $3 IS NOT NULL)
          THEN tstzrange($2, $3, '[)')
          ELSE
            NULL
          END;
          $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
          SQL
        end
      end

      dir.down do
        say_with_time "Removing calculate_visibility_range" do
          execute <<~SQL
          DROP FUNCTION calculate_visibility_range(entity_visibility, timestamptz, timestamptz);
          SQL
        end
      end
    end

    TABLES.each do |table|
      change_table table do |t|
        t.column :visible_until_at, :timestamptz, null: true
        t.column :hidden_at, :timestamptz, null: true
        t.enum :visibility, enum_type: "entity_visibility", null: false, default: "visible"
      end

      reversible do |dir|
        dir.up do
          say_with_time "Changing visible_after_at to timestamptz" do
            execute(<<~SQL)
            ALTER TABLE #{table} ALTER COLUMN visible_after_at SET DATA TYPE timestamptz;
            SQL
          end

          say_with_time "Add generated visibility_range" do
            execute(<<~SQL.strip_heredoc.squish)
            ALTER TABLE #{table}
              ADD COLUMN visibility_range tstzrange GENERATED ALWAYS AS (calculate_visibility_range(visibility, visible_after_at, visible_until_at)) STORED;
            SQL
          end
        end

        dir.down do
          remove_column table, :visibility_range

          say_with_time "Reverting visible_after_at to timestamp without timezone" do
            execute(<<~SQL)
            ALTER TABLE #{table} ALTER COLUMN visible_after_at SET DATA TYPE timestamp;
            SQL
          end
        end
      end

      change_table table do |t|
        t.index %i[visibility visibility_range], using: :gist, name: "index_#{table}_visibility_coverage"
      end
    end
  end
end
