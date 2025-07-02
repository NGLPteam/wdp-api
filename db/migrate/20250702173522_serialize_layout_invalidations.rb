# frozen_string_literal: true

class SerializeLayoutInvalidations < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.down do
        execute <<~SQL
        DROP SEQUENCE IF EXISTS layout_invalidations_sequence;
        SQL
      end
    end

    change_table :layout_invalidations do |t|
      t.bigint :sequence_id
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE SEQUENCE layout_invalidations_sequence
          AS bigint
          INCREMENT BY -1
          MINVALUE -9223372036854775808
          MAXVALUE 9223372036854775807
          START WITH 9223372036854775807
          CYCLE
          OWNED BY layout_invalidations.sequence_id
          ;
        SQL

        say_with_time "Applying sequentiality to existing layout invalidations" do
          exec_update(<<~SQL)
          WITH seq_ids AS (
            SELECT id,
              9223372036854775807 - ((dense_rank() OVER w)::bigint - 1) AS sequence_id
              FROM layout_invalidations
              WINDOW w AS (ORDER BY stale_at ASC)
          )
          UPDATE layout_invalidations li SET sequence_id = si.sequence_id
          FROM seq_ids si WHERE si.id = li.id;
          SQL
        end

        execute <<~SQL
        SELECT setval('layout_invalidations_sequence', COALESCE(MIN(sequence_id), 9223372036854775807), true)
        FROM layout_invalidations;
        SQL

        execute <<~SQL
        ALTER TABLE layout_invalidations
          ALTER COLUMN sequence_id
          SET DEFAULT nextval('layout_invalidations_sequence'),
          ALTER COLUMN sequence_id
          SET NOT NULL
        ;
        SQL
      end
    end

    change_table :layout_invalidations do |t|
      t.index :sequence_id, unique: true
    end
  end
end
