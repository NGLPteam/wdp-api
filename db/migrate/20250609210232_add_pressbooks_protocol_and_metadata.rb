# frozen_string_literal: true

class AddPressbooksProtocolAndMetadata < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        ALTER TYPE harvest_protocol ADD VALUE IF NOT EXISTS 'pressbooks';
        SQL

        execute <<~SQL
        ALTER TYPE harvest_metadata_format ADD VALUE IF NOT EXISTS 'pressbooks';
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP TYPE "underlying_data_format";
        SQL
      end
    end

    create_enum :underlying_data_format, %w[xml json]

    change_table :harvest_records do |t|
      t.enum :underlying_data_format, enum_type: :underlying_data_format, null: true

      t.jsonb :json_source
      t.jsonb :json_metadata_source

      t.rename :raw_source, :xml_source
      t.rename :raw_metadata_source, :xml_metadata_source
    end

    reversible do |dir|
      dir.up do
        say_with_time "Backfilling data_format for all existing harvest records" do
          exec_update(<<~SQL)
          UPDATE harvest_records SET underlying_data_format = 'xml';
          SQL
        end
      end
    end

    change_column_null :harvest_records, :underlying_data_format, false
  end
end
