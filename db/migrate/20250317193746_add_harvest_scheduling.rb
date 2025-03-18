# frozen_string_literal: true

class AddHarvestScheduling < ActiveRecord::Migration[7.0]
  def change
    safe_create_enum :harvest_schedule_mode, %w[manual scheduled]

    change_table :harvest_attempts do |t|
      t.rename :kind, :mode
    end

    migrate_mode_column! :harvest_mappings
    migrate_mode_column! :harvest_attempts

    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TABLE harvest_mappings
          DROP COLUMN IF EXISTS collection_id;
        SQL

        execute <<~SQL
        ALTER TABLE harvest_attempts
          DROP COLUMN IF EXISTS collection_id;
        SQL

        execute <<~SQL
        ALTER TABLE harvest_mappings
          ALTER COLUMN frequency SET DATA TYPE interval USING NULL::interval;
        SQL
      end

      dir.down do
        execute <<~SQL
        ALTER TABLE harvest_mappings
          ALTER COLUMN frequency SET DATA TYPE text USING NULL::text;
        SQL
      end
    end

    change_table :harvest_mappings do |t|
      t.timestamp :schedule_changed_at
      t.timestamp :last_scheduled_at

      t.jsonb :schedule_data, null: false, default: {}
    end

    change_table :harvest_attempts do |t|
      t.timestamp :scheduled_at

      t.text :scheduling_key

      t.index %i[harvest_mapping_id scheduling_key], unique: true,
        where: %[mode = 'scheduled' AND harvest_mapping_id IS NOT NULL AND scheduling_key IS NOT NULL],
        name: "harvest_attempts_scheduling_uniqueness"
    end
  end

  private

  def migrate_mode_column!(table)
    reversible do |dir|
      dir.up do
        mode_queries_for(table, "harvest_schedule_mode").each do |query|
          execute query
        end
      end

      dir.down do
        mode_queries_for(table, "text").each do |query|
          execute query
        end
      end
    end
  end

  def mode_queries_for(table, mode_type)
    [].tap do |queries|
      queries << <<~SQL.strip_heredoc
      ALTER TABLE #{table} ALTER COLUMN mode DROP DEFAULT;
      SQL

      queries << <<~SQL.strip_heredoc
      ALTER TABLE #{table}
        ALTER COLUMN mode
          SET DATA TYPE text USING 'manual'::#{mode_type};
      SQL

      queries << <<~SQL.strip_heredoc
      ALTER TABLE #{table}
        ALTER COLUMN mode
          SET DEFAULT 'manual'::#{mode_type};
      ;
      SQL
    end
  end

  def safe_create_enum(name, ...)
    reversible do |dir|
      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP TYPE IF EXISTS #{name};
        SQL
      end
    end

    create_enum(name, ...)
  end
end
