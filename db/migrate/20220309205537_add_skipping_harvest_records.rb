class AddSkippingHarvestRecords < ActiveRecord::Migration[6.1]
  LANG = "SQL"

  def change
    change_table :harvest_records do |t|
      t.jsonb :skipped, null: false, default: { active: false }
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION record_is_skipped(jsonb) RETURNS boolean AS $$
        SELECT jsonb_extract_boolean($1, '{active}');
        $$ LANGUAGE #{LANG} IMMUTABLE PARALLEL SAFE;
        SQL

        execute <<~SQL
        ALTER TABLE harvest_records ADD COLUMN has_been_skipped boolean NOT NULL GENERATED ALWAYS AS (record_is_skipped(skipped)) STORED;
        SQL

        add_index :harvest_records, :has_been_skipped
      end

      dir.down do
        remove_column :harvest_records, :has_been_skipped

        execute <<~SQL
        DROP FUNCTION record_is_skipped(jsonb);
        SQL
      end
    end
  end
end
