class CreateEntityVisibilities < ActiveRecord::Migration[6.1]
  TABLES = %i[collections items].freeze

  def change
    create_table :entity_visibilities, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid, index: { unique: true }

      t.column :visible_after_at, :timestamptz, null: true
      t.column :visible_until_at, :timestamptz, null: true
      t.column :hidden_at, :timestamptz, null: true
      t.enum :visibility, enum_type: "entity_visibility", null: false, default: "visible"

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    reversible do |dir|
      dir.up do
        execute(<<~SQL)
        ALTER TABLE entity_visibilities ALTER COLUMN entity_type SET DATA TYPE text;
        SQL

        say_with_time "Populating entity visibilities from items" do
          execute(<<~SQL).cmdtuples
          INSERT INTO entity_visibilities
          (entity_type, entity_id, visible_after_at, visible_until_at, hidden_at, visibility, created_at, updated_at)
          SELECT 'Item' AS entity_type, id AS entity_id, visible_after_at, visible_until_at, hidden_at, visibility, created_at, updated_at
          FROM items
          SQL
        end

        say_with_time "Populating entity visibilities from collections" do
          execute(<<~SQL).cmdtuples
          INSERT INTO entity_visibilities
          (entity_type, entity_id, visible_after_at, visible_until_at, hidden_at, visibility, created_at, updated_at)
          SELECT 'Collection' AS entity_type, id AS entity_id, visible_after_at, visible_until_at, hidden_at, visibility, created_at, updated_at
          FROM collections
          SQL
        end

        add_visibility_range_and_index_to! :entity_visibilities, with_fk: true

        TABLES.each do |table|
          remove_column table, :visibility_range
          remove_column table, :visible_after_at
          remove_column table, :visible_until_at
          remove_column table, :hidden_at
          remove_column table, :visibility
        end
      end

      dir.down do
        TABLES.each do |table|
          change_table table do |t|
            t.column :visible_after_at, :timestamptz, null: true
            t.column :visible_until_at, :timestamptz, null: true
            t.column :hidden_at, :timestamptz, null: true
            t.enum :visibility, enum_type: "entity_visibility", null: false, default: "visible"
          end

          add_visibility_range_and_index_to! table, with_fk: false

          klass_name = connection.quote table.to_s.classify
          table_name = connection.quote_table_name table

          say_with_time "Repopulating entity visibilities for #{table}" do
            execute(<<~SQL).cmdtuples
            UPDATE #{table_name} AS ent SET visible_after_at = ev.visible_after_at, visible_until_at = ev.visible_until_at, hidden_at = ev.hidden_at, visibility = ev.visibility
            FROM entity_visibilities AS ev
            WHERE ev.entity_type = #{klass_name} AND ev.entity_id = ent.id;
            SQL
          end
        end
      end
    end
  end

  private

  def add_visibility_range_and_index_to!(table, with_fk: false)
    quoted_table = connection.quote_table_name table

    say_with_time "Adding generated visibility_range to #{table}" do
      execute(<<~SQL)
      ALTER TABLE #{quoted_table}
        ADD COLUMN visibility_range tstzrange GENERATED ALWAYS AS (calculate_visibility_range(visibility, visible_after_at, visible_until_at)) STORED
      ;
      SQL
    end

    columns = %i[visibility visibility_range]

    columns += %i[entity_type entity_id] if with_fk

    change_table table do |t|
      t.index columns, using: :gist, name: "index_#{table}_visibility_coverage"
    end
  end
end
